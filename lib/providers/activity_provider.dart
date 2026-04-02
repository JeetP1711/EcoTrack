import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/activity_model.dart';
import '../services/database_service.dart';
import '../services/emission_service.dart';

/// Provider managing activities and emission calculations.
class ActivityProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final EmissionService _emissionService = EmissionService();
  static const _uuid = Uuid();

  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _userId;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;

  /// Set user ID and load activities.
  Future<void> initialize(String userId) async {
    _userId = userId;
    await loadActivities();
  }

  /// Load all activities from database.
  Future<void> loadActivities() async {
    if (_userId == null) return;

    _isLoading = true;
    notifyListeners();

    _activities = await _dbService.getActivities(_userId!);

    _isLoading = false;
    notifyListeners();
  }

  /// Log a new activity.
  Future<int> logActivity({
    required String category,
    required String name,
    required double value,
    required String unit,
  }) async {
    if (_userId == null) return 0;

    final co2 = _emissionService.calculateEmission(name, value);

    final activity = ActivityModel(
      id: _uuid.v4(),
      category: category,
      name: name,
      value: value,
      unit: unit,
      co2Emission: co2,
      timestamp: DateTime.now(),
    );

    await _dbService.saveActivity(_userId!, activity);
    _activities.insert(0, activity);
    notifyListeners();

    // Return points earned (base calculation, provider decides bonus)
    return 10;
  }

  /// Delete an activity.
  Future<void> deleteActivity(String activityId) async {
    if (_userId == null) return;

    await _dbService.deleteActivity(_userId!, activityId);
    _activities.removeWhere((a) => a.id == activityId);
    notifyListeners();
  }

  // ─── Aggregation Methods ──────────────────────────────────────

  /// Get total emissions for today.
  double get todayEmissions {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return _activities
        .where((a) => a.timestamp.isAfter(startOfDay))
        .fold(0.0, (sum, a) => sum + a.co2Emission);
  }

  /// Get total emissions for this week.
  double get weeklyEmissions {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return _activities
        .where((a) => a.timestamp.isAfter(start))
        .fold(0.0, (sum, a) => sum + a.co2Emission);
  }

  /// Get total emissions for this month.
  double get monthlyEmissions {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return _activities
        .where((a) => a.timestamp.isAfter(start))
        .fold(0.0, (sum, a) => sum + a.co2Emission);
  }

  /// Get emissions by category for a given period.
  Map<String, double> getEmissionsByCategory({String period = 'Daily'}) {
    final filteredActivities = _getActivitiesForPeriod(period);
    final result = <String, double>{
      'Transport': 0,
      'Food': 0,
      'Energy': 0,
    };

    for (final a in filteredActivities) {
      result[a.category] = (result[a.category] ?? 0) + a.co2Emission;
    }

    return result;
  }

  /// Get daily emissions for the last 7 days.
  List<MapEntry<String, double>> getDailyEmissionsForWeek() {
    final now = DateTime.now();
    final result = <MapEntry<String, double>>[];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final startOfDay = DateTime(day.year, day.month, day.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final total = _activities
          .where((a) =>
              a.timestamp.isAfter(startOfDay) &&
              a.timestamp.isBefore(endOfDay))
          .fold(0.0, (sum, a) => sum + a.co2Emission);

      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      result.add(MapEntry(dayNames[day.weekday - 1], total));
    }

    return result;
  }

  /// Get recent activities (limited).
  List<ActivityModel> getRecentActivities({int limit = 5}) {
    return _activities.take(limit).toList();
  }

  /// Get activities filtered by category.
  List<ActivityModel> getActivitiesByCategory(String category) {
    return _activities.where((a) => a.category == category).toList();
  }

  /// Total emissions all time.
  double get totalEmissions {
    return _activities.fold(0.0, (sum, a) => sum + a.co2Emission);
  }

  /// Total activities count.
  int get totalActivitiesCount => _activities.length;

  // ─── Private Helpers ──────────────────────────────────────────

  List<ActivityModel> _getActivitiesForPeriod(String period) {
    final now = DateTime.now();
    DateTime start;

    switch (period) {
      case 'Weekly':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        break;
      case 'Monthly':
        start = DateTime(now.year, now.month, 1);
        break;
      default: // Daily
        start = DateTime(now.year, now.month, now.day);
    }

    return _activities.where((a) => a.timestamp.isAfter(start)).toList();
  }
}

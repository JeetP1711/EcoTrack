import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity_model.dart';

/// Mock database service that mirrors Firestore API.
/// Stores activities in SharedPreferences as JSON.
/// Can be swapped with real Firestore later.
class DatabaseService {
  /// Save an activity for the current user.
  Future<void> saveActivity(String userId, ActivityModel activity) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ecotrack_activities_$userId';

    final existing = prefs.getString(key) ?? '[]';
    final activities = List<Map<String, dynamic>>.from(
      (jsonDecode(existing) as List).map((e) => Map<String, dynamic>.from(e)),
    );

    activities.add(activity.toJson());
    await prefs.setString(key, jsonEncode(activities));
  }

  /// Get all activities for a user.
  Future<List<ActivityModel>> getActivities(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ecotrack_activities_$userId';

    final existing = prefs.getString(key) ?? '[]';
    final activities = (jsonDecode(existing) as List)
        .map((e) => ActivityModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    // Sort by timestamp descending (newest first)
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities;
  }

  /// Delete an activity by ID.
  Future<void> deleteActivity(String userId, String activityId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ecotrack_activities_$userId';

    final existing = prefs.getString(key) ?? '[]';
    final activities = (jsonDecode(existing) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .where((e) => e['id'] != activityId)
        .toList();

    await prefs.setString(key, jsonEncode(activities));
  }

  /// Get activities within a date range.
  Future<List<ActivityModel>> getActivitiesByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final all = await getActivities(userId);
    return all
        .where((a) => a.timestamp.isAfter(start) && a.timestamp.isBefore(end))
        .toList();
  }

  /// Get activities for today.
  Future<List<ActivityModel>> getTodayActivities(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getActivitiesByDateRange(userId, startOfDay, endOfDay);
  }

  /// Clear all activities for a user.
  Future<void> clearActivities(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ecotrack_activities_$userId');
  }
}

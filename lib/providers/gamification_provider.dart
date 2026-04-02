import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/gamification_service.dart';

/// Provider for gamification state: points, level, streaks.
class GamificationProvider with ChangeNotifier {
  final GamificationService _service = GamificationService();

  int _totalPoints = 0;
  int _streakDays = 0;

  int get totalPoints => _totalPoints;
  int get streakDays => _streakDays;
  int get level => _service.getLevel(_totalPoints);
  String get levelName => _service.getLevelName(_totalPoints);
  double get progressToNextLevel =>
      _service.getProgressToNextLevel(_totalPoints);
  int get pointsToNextLevel => _service.pointsToNextLevel(_totalPoints);

  /// Initialize with stored values.
  void initialize(int totalPoints, int streakDays) {
    _totalPoints = totalPoints;
    _streakDays = streakDays;
    notifyListeners();
  }

  /// Award points for a new activity.
  int awardPoints(ActivityModel activity) {
    final points = _service.calculateActivityPoints(activity);
    _totalPoints += points;
    notifyListeners();
    return points;
  }

  /// Award streak bonus.
  int awardStreakBonus() {
    final bonus = _service.calculateStreakBonus(_streakDays);
    if (bonus > 0) {
      _totalPoints += bonus;
      notifyListeners();
    }
    return bonus;
  }

  /// Increment streak.
  void incrementStreak() {
    _streakDays++;
    notifyListeners();
  }

  /// Reset streak.
  void resetStreak() {
    _streakDays = 0;
    notifyListeners();
  }

  /// Set points directly (for loading from storage).
  void setPoints(int points) {
    _totalPoints = points;
    notifyListeners();
  }
}

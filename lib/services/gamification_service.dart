import '../core/constants.dart';
import '../models/activity_model.dart';

/// Service for gamification logic: points, levels, and streaks.
class GamificationService {
  /// Calculate points earned for logging an activity.
  int calculateActivityPoints(ActivityModel activity) {
    int points = AppConstants.pointsPerActivity;

    // Bonus points for low-emission activities
    if (activity.co2Emission < AppConstants.lowEmissionThreshold) {
      points += AppConstants.pointsPerLowEmission;
    }

    // Bonus for zero-emission activities
    if (activity.co2Emission == 0) {
      points += 15;
    }

    return points;
  }

  /// Get the current level based on total points.
  int getLevel(int totalPoints) {
    int level = 0;
    for (int i = 0; i < AppConstants.levelThresholds.length; i++) {
      if (totalPoints >= AppConstants.levelThresholds[i]) {
        level = i;
      }
    }
    return level;
  }

  /// Get the level name.
  String getLevelName(int totalPoints) {
    final level = getLevel(totalPoints);
    return AppConstants.levelNames[level];
  }

  /// Get progress percentage to next level (0.0 to 1.0).
  double getProgressToNextLevel(int totalPoints) {
    final level = getLevel(totalPoints);
    if (level >= AppConstants.levelThresholds.length - 1) return 1.0;

    final currentThreshold = AppConstants.levelThresholds[level];
    final nextThreshold = AppConstants.levelThresholds[level + 1];
    final range = nextThreshold - currentThreshold;
    final progress = totalPoints - currentThreshold;

    return (progress / range).clamp(0.0, 1.0);
  }

  /// Get points needed for next level.
  int pointsToNextLevel(int totalPoints) {
    final level = getLevel(totalPoints);
    if (level >= AppConstants.levelThresholds.length - 1) return 0;
    return AppConstants.levelThresholds[level + 1] - totalPoints;
  }

  /// Calculate streak bonus.
  int calculateStreakBonus(int streakDays) {
    if (streakDays >= 7) return AppConstants.pointsPerStreak;
    if (streakDays >= 3) return AppConstants.pointsPerStreak ~/ 2;
    return 0;
  }
}

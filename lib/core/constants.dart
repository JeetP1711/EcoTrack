// App-wide constants for EcoTrack.

class AppConstants {
  // ─── App Info ───────────────────────────────────────────────────
  static const String appName = 'EcoTrack';
  static const String appTagline = 'Carbon Footprint Assistant';
  static const String appVersion = '1.0.0';

  // ─── Route Names ────────────────────────────────────────────────
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String calculatorRoute = '/calculator';
  static const String activityLoggerRoute = '/activity-logger';
  static const String profileRoute = '/profile';

  // ─── Storage Keys ───────────────────────────────────────────────
  static const String userKey = 'ecotrack_user';
  static const String activitiesKey = 'ecotrack_activities';
  static const String pointsKey = 'ecotrack_points';
  static const String streakKey = 'ecotrack_streak';
  static const String lastLoginKey = 'ecotrack_last_login';
  static const String isLoggedInKey = 'ecotrack_is_logged_in';

  // ─── Emission Categories ────────────────────────────────────────
  static const String categoryTransport = 'Transport';
  static const String categoryFood = 'Food';
  static const String categoryEnergy = 'Energy';

  // ─── Gamification ───────────────────────────────────────────────
  static const int pointsPerActivity = 10;
  static const int pointsPerLowEmission = 25;
  static const int pointsPerStreak = 50;
  static const double lowEmissionThreshold = 2.0; // kg CO2

  static const List<String> levelNames = [
    'Seedling',
    'Sprout',
    'Sapling',
    'Tree',
    'Forest',
    'Rainforest',
    'Ecosystem',
    'Planet Saver',
  ];

  static const List<int> levelThresholds = [
    0,
    100,
    300,
    600,
    1000,
    1600,
    2500,
    4000,
  ];

  // ─── Chart Period ───────────────────────────────────────────────
  static const List<String> periods = ['Daily', 'Weekly', 'Monthly'];
}

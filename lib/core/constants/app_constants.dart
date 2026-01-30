/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Task Flow';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'taskflow.db';
  static const int databaseVersion = 1;

  // Tables
  static const String tasksTable = 'tasks';
  static const String categoriesTable = 'categories';

  // Shared Preferences Keys
  static const String themeKey = 'theme_mode';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String appLockEnabledKey = 'app_lock_enabled';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Default Values
  static const int defaultPriority = 0;
}

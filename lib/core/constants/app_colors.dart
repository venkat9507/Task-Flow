import 'package:flutter/material.dart';

/// Application color palette
class AppColors {
  AppColors._();

  // ============ Light Theme Colors ============
  static const Color primaryLight = Color(0xFF5C6BC0);
  static const Color primaryVariantLight = Color(0xFF3949AB);
  static const Color secondaryLight = Color(0xFFFF7043);
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF1A1A2E);
  static const Color onBackgroundLight = Color(0xFF2D2D44);

  // ============ Dark Theme Colors ============
  static const Color primaryDark = Color(0xFF7986CB);
  static const Color primaryVariantDark = Color(0xFF5C6BC0);
  static const Color secondaryDark = Color(0xFFFF8A65);
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color onSurfaceDark = Color(0xFFE8E8F0);
  static const Color onBackgroundDark = Color(0xFFCCCCDD);

  // ============ Priority Colors ============
  static const Color priorityHigh = Color(0xFFEF5350);
  static const Color priorityMedium = Color(0xFFFFA726);
  static const Color priorityLow = Color(0xFF66BB6A);
  static const Color priorityNone = Color(0xFF9E9E9E);

  // ============ Category Default Colors ============
  static const List<Color> categoryColors = [
    Color(0xFF5C6BC0), // Indigo
    Color(0xFFEF5350), // Red
    Color(0xFFFF7043), // Deep Orange
    Color(0xFFFFA726), // Orange
    Color(0xFFFFCA28), // Amber
    Color(0xFF66BB6A), // Green
    Color(0xFF26A69A), // Teal
    Color(0xFF42A5F5), // Blue
    Color(0xFF7E57C2), // Deep Purple
    Color(0xFFEC407A), // Pink
    Color(0xFF8D6E63), // Brown
    Color(0xFF78909C), // Blue Grey
  ];

  // ============ Semantic Colors ============
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // ============ Gradient Colors ============
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primaryVariantLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF7043), Color(0xFFFF5722)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ Helper Methods ============
  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return priorityHigh;
      case 2:
        return priorityMedium;
      case 1:
        return priorityLow;
      default:
        return priorityNone;
    }
  }

  static String getPriorityLabel(int priority) {
    switch (priority) {
      case 3:
        return 'High';
      case 2:
        return 'Medium';
      case 1:
        return 'Low';
      default:
        return 'None';
    }
  }
}

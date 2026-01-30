import 'package:flutter/services.dart';

/// Utility class for haptic feedback
class HapticUtils {
  HapticUtils._();

  /// Light impact feedback - for subtle UI interactions
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact feedback - for button taps
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact feedback - for significant actions
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click - for toggling items
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate - for errors or warnings
  static Future<void> vibrate() async {
    await HapticFeedback.vibrate();
  }

  /// Success feedback - light double tap
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.lightImpact();
  }

  /// Error feedback - heavy vibration
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }

  /// Toggle feedback - for checkboxes and switches
  static Future<void> toggle() async {
    await HapticFeedback.selectionClick();
  }

  /// Button tap feedback
  static Future<void> buttonTap() async {
    await HapticFeedback.lightImpact();
  }

  /// Delete action feedback
  static Future<void> delete() async {
    await HapticFeedback.mediumImpact();
  }
}

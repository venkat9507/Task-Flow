import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';

part 'theme_provider.g.dart';

/// Theme mode provider
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  late final SharedPreferences _prefs;

  @override
  ThemeMode build() {
    _prefs = getIt<SharedPreferences>();
    return _loadThemeMode();
  }

  ThemeMode _loadThemeMode() {
    final themeName = _prefs.getString(AppConstants.themeKey);
    switch (themeName) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _prefs.setString(AppConstants.themeKey, mode.name);
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}

/// Convenience provider for easy access to theme mode
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeModeNotifierProvider);
});

/// Provider to check if dark mode is active
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.system) {
    // This would need to check the platform brightness
    // For now, default to false
    return false;
  }
  return themeMode == ThemeMode.dark;
});

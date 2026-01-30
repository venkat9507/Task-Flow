import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  // ============ Light Theme ============
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: AppColors.primaryLight,
        primaryContainer: Color(0xFFE8EAF6),
        secondary: AppColors.secondaryLight,
        secondaryContainer: Color(0xFFFFE0D9),
        tertiary: Color(0xFF26A69A),
        tertiaryContainer: Color(0xFFB2DFDB),
        appBarColor: AppColors.primaryLight,
        error: AppColors.error,
      ),
      surface: AppColors.surfaceLight,
      scaffoldBackground: AppColors.backgroundLight,
      appBarStyle: FlexAppBarStyle.primary,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        blendOnLevel: 10,
        blendOnColors: true,
        useM2StyleDividerInM3: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 12.0,
        inputDecoratorUnfocusedBorderIsColored: false,
        chipRadius: 20.0,
        cardRadius: 16.0,
        filledButtonRadius: 12.0,
        elevatedButtonRadius: 12.0,
        outlinedButtonRadius: 12.0,
        textButtonRadius: 12.0,
        fabRadius: 16.0,
        fabUseShape: true,
        bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
        bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimaryContainer,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.inter().fontFamily,
    ).copyWith(
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: _buildAppBarTheme(Brightness.light),
      floatingActionButtonTheme: _buildFabTheme(),
      cardTheme: _buildCardTheme(Brightness.light),
      snackBarTheme: _buildSnackBarTheme(),
    );
  }

  // ============ Dark Theme ============
  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: AppColors.primaryDark,
        primaryContainer: Color(0xFF3949AB),
        secondary: AppColors.secondaryDark,
        secondaryContainer: Color(0xFFBF360C),
        tertiary: Color(0xFF4DB6AC),
        tertiaryContainer: Color(0xFF00695C),
        appBarColor: AppColors.surfaceDark,
        error: AppColors.error,
      ),
      surface: AppColors.surfaceDark,
      scaffoldBackground: AppColors.backgroundDark,
      appBarStyle: FlexAppBarStyle.surface,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        blendOnLevel: 20,
        blendOnColors: true,
        useM2StyleDividerInM3: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 12.0,
        inputDecoratorUnfocusedBorderIsColored: false,
        chipRadius: 20.0,
        cardRadius: 16.0,
        filledButtonRadius: 12.0,
        elevatedButtonRadius: 12.0,
        outlinedButtonRadius: 12.0,
        textButtonRadius: 12.0,
        fabRadius: 16.0,
        fabUseShape: true,
        bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
        bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarSelectedIconSchemeColor: SchemeColor.onPrimaryContainer,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarIndicatorSchemeColor: SchemeColor.primaryContainer,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.inter().fontFamily,
    ).copyWith(
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: _buildAppBarTheme(Brightness.dark),
      floatingActionButtonTheme: _buildFabTheme(),
      cardTheme: _buildCardTheme(Brightness.dark),
      snackBarTheme: _buildSnackBarTheme(),
    );
  }

  // ============ Text Theme ============
  static TextTheme _buildTextTheme(Brightness brightness) {
    final Color textColor = brightness == Brightness.light
        ? AppColors.onSurfaceLight
        : AppColors.onSurfaceDark;

    return TextTheme(
      displayLarge: GoogleFonts.outfit(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor.withValues(alpha: 0.7),
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColor.withValues(alpha: 0.7),
      ),
    );
  }

  // ============ AppBar Theme ============
  static AppBarTheme _buildAppBarTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: false,
      backgroundColor: isLight
          ? AppColors.backgroundLight
          : AppColors.surfaceDark,
      foregroundColor: isLight
          ? AppColors.onSurfaceLight
          : AppColors.onSurfaceDark,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isLight ? AppColors.onSurfaceLight : AppColors.onSurfaceDark,
      ),
    );
  }

  // ============ FAB Theme ============
  static FloatingActionButtonThemeData _buildFabTheme() {
    return FloatingActionButtonThemeData(
      elevation: 4,
      highlightElevation: 8,
      backgroundColor: AppColors.primaryLight,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  // ============ Card Theme ============
  static CardThemeData _buildCardTheme(Brightness brightness) {
    final bool isLight = brightness == Brightness.light;

    return CardThemeData(
      elevation: isLight ? 2 : 4,
      shadowColor: isLight
          ? Colors.black.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
    );
  }

  // ============ SnackBar Theme ============
  static SnackBarThemeData _buildSnackBarTheme() {
    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

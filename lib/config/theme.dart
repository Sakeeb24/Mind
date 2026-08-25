import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Taste Skill: Color is used sparingly with purpose.
/// Most surfaces are neutral; accent is reserved for primary actions.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B83FF);
  static const Color primaryDark = Color(0xFF5A52E0);
  static const Color primarySubtle = Color(0xFFEEEDFF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const Color highlightYellow = Color(0xFFFFEB3B);
  static const Color highlightGreen = Color(0xFF66BB6A);
  static const Color highlightBlue = Color(0xFF42A5F5);
  static const Color highlightPink = Color(0xFFEC407A);

  static const Color lightBackground = Color(0xFFFAFBFD);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightDivider = Color(0xFFE5E7EB);

  static const Color darkBackground = Color(0xFF0B0F1A);
  static const Color darkSurface = Color(0xFF151A28);
  static const Color darkSurfaceVariant = Color(0xFF1E2436);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextTertiary = Color(0xFF6B7280);
  static const Color darkDivider = Color(0xFF1F2937);
}

/// Taste Skill: Typography is the backbone of visual hierarchy.
class AppTypography {
  AppTypography._();

  static const TextStyle display = TextStyle(
    fontFamily: 'Inter', fontSize: 32, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Inter', fontSize: 24, fontWeight: FontWeight.w700, height: 1.3, letterSpacing: -0.3,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, height: 1.3,
  );
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, height: 1.4,
  );
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w600, height: 1.4,
  );
  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, height: 1.4,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w400, height: 1.6,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400, height: 1.5,
  );
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, height: 1.4, letterSpacing: 0.3,
  );
}

/// Taste Skill: Spacing breathes. Consistent vertical rhythm.
class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary, brightness: Brightness.light,
      primary: AppColors.primary, secondary: AppColors.secondary,
      error: AppColors.error, surface: AppColors.lightSurface,
    );
    return ThemeData(
      useMaterial3: true, brightness: Brightness.light, colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightSurface, foregroundColor: AppColors.lightTextPrimary,
        elevation: 0, scrolledUnderElevation: 0.5, centerTitle: false,
        titleTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.lightDivider, width: 0.5)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.lightTextTertiary, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, foregroundColor: Colors.white,
          minimumSize: const Size(0, 50), padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary, minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: const BorderSide(color: AppColors.lightDivider, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 2, shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.lightDivider, thickness: 0.5),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: { TargetPlatform.android: CupertinoPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder() },
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary, brightness: Brightness.dark,
      primary: AppColors.primaryLight, secondary: AppColors.secondary,
      error: const Color(0xFFF87171), surface: AppColors.darkSurface,
    );
    return ThemeData(
      useMaterial3: true, brightness: Brightness.dark, colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface, foregroundColor: AppColors.darkTextPrimary,
        elevation: 0, scrolledUnderElevation: 0.5, centerTitle: false,
        titleTextStyle: TextStyle(fontFamily: 'Inter', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface, elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.darkDivider, width: 0.5)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.darkTextTertiary, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight, foregroundColor: AppColors.darkBackground,
          minimumSize: const Size(0, 50), padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight, minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          side: const BorderSide(color: AppColors.darkDivider, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight, foregroundColor: AppColors.darkBackground, elevation: 2, shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.darkDivider, thickness: 0.5),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: { TargetPlatform.android: CupertinoPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder() },
      ),
    );
  }
}

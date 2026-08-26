import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MindSpace Stitch Design System: Deep Focus Academic & Tactile Glassmorphism
/// Visual Source of Truth: Google Stitch Project ID: 15571688923212314587
class AppColors {
  AppColors._();

  // Foundation / Canvas Layer (Obsidian Base)
  static const Color obsidian = Color(0xFF0B0F17);       // Base canvas background (Level 0)
  static const Color surfaceContainerLowest = Color(0xFF0D0D15);
  static const Color surfaceContainerLow = Color(0xFF1B1B23);
  static const Color surfaceContainer = Color(0xFF1F1F27);
  static const Color surfaceContainerHigh = Color(0xFF292932);
  static const Color surfaceContainerHighest = Color(0xFF34343D);
  static const Color surfaceBright = Color(0xFF393841);

  // Surface Hierarchy
  static const Color navySlate = Color(0xFF131B2E);      // Primary panels & sidebars
  static const Color cardRaised = Color(0xFF1E293B);     // Raised cards & containers
  static const Color interactive = Color(0xFF283548);    // Hover / Active input fills

  // Brand & Action Accents
  static const Color electricIndigo = Color(0xFF6366F1); // Primary action accent
  static const Color indigoContainer = Color(0xFF494BD6);
  static const Color primaryFixed = Color(0xFFE1E0FF);
  static const Color primaryFixedDim = Color(0xFFC0C1FF);
  static const Color cyanGlow = Color(0xFF4CD7F6);       // AI intelligence spark & citations
  static const Color cyanContainer = Color(0xFF03B5D3);
  static const Color amberGold = Color(0xFFFFB783);      // Tertiary / Highlights / Streaks
  static const Color amberContainer = Color(0xFFD97721);

  // Borders & Dividers
  static const Color whisperBorder = Color(0x2494A3B8);        // rgba(148, 163, 184, 0.14)
  static const Color whisperBorderBright = Color(0x4094A3B8);  // rgba(148, 163, 184, 0.25)
  static const Color outlineVariant = Color(0xFF464554);

  // Compatibility aliases
  static const Color primary = electricIndigo;
  static const Color primaryLight = Color(0xFFC0C1FF);
  static const Color primaryDark = Color(0xFF494BD6);
  static const Color primarySubtle = Color(0x1F6366F1);
  static const Color secondary = cyanGlow;
  static const Color secondaryContainer = cyanContainer;
  static const Color glowingCyan = cyanGlow;
  static const Color tertiary = amberGold;

  static const Color success = Color(0xFF10B981); // Emerald Sage
  static const Color warning = Color(0xFFF59E0B); // Amber Gold
  static const Color error = Color(0xFFFFB4AB);   // Rose Red / Error
  static const Color errorContainer = Color(0xFF93000A);

  // Semantic 4-Color Annotation Highlight Tokens
  static const Color highlightYellow = Color(0xFFF59E0B); // Amber Gold (Key concepts)
  static const Color highlightGreen = Color(0xFF10B981);  // Emerald Sage (Definitions)
  static const Color highlightBlue = Color(0xFF3B82F6);   // Cobalt Frost (Data/Evidence)
  static const Color highlightPink = Color(0xFFF43F5E);   // Rose Petal (Questions/Doubts)

  // Light Canvas & Surfaces
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // Dark Canvas & Surfaces
  static const Color darkBackground = obsidian;
  static const Color darkSurface = navySlate;
  static const Color darkSurfaceVariant = cardRaised;
  static const Color darkInteractive = interactive;
  static const Color darkTextPrimary = Color(0xFFE4E1ED);
  static const Color darkTextSecondary = Color(0xFFC7C4D7);
  static const Color darkTextTertiary = Color(0xFF908FA0);
  static const Color darkDivider = whisperBorder;
}

/// MindSpace Stitch Typography using Plus Jakarta Sans & JetBrains Mono
class AppTypography {
  AppTypography._();

  static TextStyle displayLarge = GoogleFonts.plusJakartaSans(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.02,
  );

  static TextStyle displayMedium = GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.02,
  );

  static TextStyle display = displayMedium;

  static TextStyle headlineLarge = GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.01,
  );

  static TextStyle headlineMedium = GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle headlineSmall = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle titleLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle titleMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.55,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle labelLarge = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.05,
  );

  static TextStyle labelSmall = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.05,
  );

  static TextStyle citation = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static TextStyle math = GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}

/// Consistent 4px rhythm spacing
class AppSpacing {
  AppSpacing._();
  static const double unit = 4;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 40;
  static const double xxl = 48;
}

/// Stitch Glassmorphism and Shadow decorations
class AppDecorations {
  AppDecorations._();

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 40,
      offset: Offset(0, 20),
    ),
    BoxShadow(
      color: Color(0x0D6366F1),
      blurRadius: 10,
      offset: Offset(0, 0),
    ),
  ];

  static const List<BoxShadow> cyanGlowShadow = [
    BoxShadow(
      color: Color(0x4D4CD7F6),
      blurRadius: 12,
      offset: Offset(0, 0),
    ),
  ];

  static BoxDecoration glassPanel({bool isDark = true, double radius = 16}) {
    return BoxDecoration(
      color: isDark ? const Color(0xCC131B2E) : Colors.white.withAlpha(240),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isDark ? AppColors.whisperBorder : AppColors.lightDivider,
        width: 1,
      ),
      boxShadow: softShadow,
    );
  }

  static BoxDecoration glassOverlay({bool isDark = true, double radius = 9999}) {
    return BoxDecoration(
      color: isDark ? const Color(0xD9131B2E) : Colors.white.withAlpha(230),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: isDark ? AppColors.whisperBorderBright : AppColors.lightDivider,
        width: 1,
      ),
      boxShadow: softShadow,
    );
  }
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      surface: AppColors.lightSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightDivider, width: 0.8),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          color: AppColors.lightTextTertiary,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          side: const BorderSide(color: AppColors.lightDivider, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.lightDivider, thickness: 0.5),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryFixedDim,
      secondary: AppColors.cyanGlow,
      tertiary: AppColors.amberGold,
      error: AppColors.error,
      surface: AppColors.surfaceContainer,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.navySlate,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.navySlate,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.whisperBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.whisperBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.cyanGlow, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          color: AppColors.darkTextTertiary,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.indigoContainer,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          side: const BorderSide(color: AppColors.whisperBorder, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.whisperBorder, thickness: 1),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

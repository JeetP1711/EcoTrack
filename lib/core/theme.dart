import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// EcoTrack premium dark/green theme with Material 3.
class EcoTheme {
  // ─── Brand Colors ───────────────────────────────────────────────
  static const Color darkBg = Color(0xFF0A0E14);
  static const Color cardBg = Color(0xFF141B24);
  static const Color surfaceBg = Color(0xFF1A2332);
  static const Color greenDark = Color(0xFF1B4332);
  static const Color greenMid = Color(0xFF2D6A4F);
  static const Color greenPrimary = Color(0xFF40916C);
  static const Color greenLight = Color(0xFF52B788);
  static const Color greenAccent = Color(0xFF95D5B2);
  static const Color greenPale = Color(0xFFD8F3DC);
  static const Color white = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF8899AA);
  static const Color textMuted = Color(0xFF5A6A7A);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFD93D);
  static const Color info = Color(0xFF4ECDC4);

  // ─── Category Colors ────────────────────────────────────────────
  static const Color transportColor = Color(0xFF4ECDC4);
  static const Color foodColor = Color(0xFFFF6B6B);
  static const Color energyColor = Color(0xFFFFD93D);

  // ─── Gradients ──────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [greenMid, greenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBg, Color(0xFF0D1B2A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2332), Color(0xFF141B24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Decorations ────────────────────────────────────────────────
  static BoxDecoration get glassCard => BoxDecoration(
    color: cardBg.withValues(alpha: 0.7),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: greenPrimary.withValues(alpha: 0.15), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration get accentCard => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: greenPrimary.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // ─── Theme Data ─────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: greenPrimary,
        secondary: greenLight,
        surface: surfaceBg,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: white,
      ),
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: white,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: white,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: white,
          fontSize: 16,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: textSecondary,
          fontSize: 14,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          color: textMuted,
          fontSize: 12,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          color: white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: white),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: greenPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: greenPrimary.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: greenPrimary.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: greenPrimary, width: 2),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBg,
        selectedItemColor: greenLight,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceBg,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

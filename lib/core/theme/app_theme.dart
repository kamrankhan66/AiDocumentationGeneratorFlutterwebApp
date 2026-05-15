import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color backgroundColor = Color(0xFF0F172A); // Dark blue
  static const Color surfaceColor = Color(0xFF1E293B); // Lighter dark blue
  static const Color cardColor = Color(0xFF334155); // Card background
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);

  // Text Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColor, Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.inter(
              fontSize: 57,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            displayMedium: GoogleFonts.inter(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            displaySmall: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            headlineLarge: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
            headlineMedium: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            headlineSmall: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            titleLarge: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            titleMedium: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
            titleSmall: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
            bodyLarge: GoogleFonts.inter(fontSize: 16, color: textPrimary),
            bodyMedium: GoogleFonts.inter(fontSize: 14, color: textSecondary),
            bodySmall: GoogleFonts.inter(fontSize: 12, color: textTertiary),
            labelLarge: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
          ),
      cardTheme: CardThemeData(
        color: surfaceColor.withValues(alpha: 0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorColor: primaryColor,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Card Decoration with Gradient Border
  static BoxDecoration cardDecoration({
    Gradient? gradient,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient:
          gradient ??
          LinearGradient(
            colors: [
              surfaceColor.withValues(alpha: 0.8),
              surfaceColor.withValues(alpha: 0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Glassmorphism Box Decoration
  static BoxDecoration glassDecoration({
    double blur = 10,
    double opacity = 0.1,
    Color? color,
    BorderRadius? borderRadius,
    Border? border,
  }) {
    return BoxDecoration(
      color: (color ?? Colors.white).withValues(alpha: opacity),
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      border:
          border ??
          Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Gradient Button Decoration
  static BoxDecoration gradientButtonDecoration({
    Gradient? gradient,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      gradient: gradient ?? primaryGradient,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

// Made with Bob

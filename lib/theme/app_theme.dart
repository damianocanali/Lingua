import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette - warm, inviting colors
  static const primary = Color(0xFF6C63FF); // Friendly purple
  static const primaryLight = Color(0xFFA29BFE);
  static const primaryDark = Color(0xFF4A42D4);

  // Accent colors - high contrast for ADHD engagement
  static const orange = Color(0xFFFF6B35);
  static const green = Color(0xFF2ECC71);
  static const pink = Color(0xFFFF6B9D);
  static const yellow = Color(0xFFFFD93D);
  static const blue = Color(0xFF4ECDC4);
  static const red = Color(0xFFFF6B6B);

  // Category colors
  static const animals = Color(0xFF55E6C1);
  static const food = Color(0xFFFF9FF3);
  static const family = Color(0xFFFF6B6B);
  static const colors = Color(0xFFFECA57);
  static const numbers = Color(0xFF48DBFB);
  static const body = Color(0xFFFF9F43);
  static const greetings = Color(0xFFA29BFE);
  static const nature = Color(0xFF2ECC71);

  // Background
  static const background = Color(0xFFF8F9FE);
  static const cardBackground = Colors.white;
  static const surface = Color(0xFFF0F0FF);

  // Text
  static const textPrimary = Color(0xFF2D3436);
  static const textSecondary = Color(0xFF636E72);
  static const textLight = Colors.white;

  // Feedback
  static const correct = Color(0xFF2ECC71);
  static const incorrect = Color(0xFFFF6B6B);
  static const star = Color(0xFFFFD700);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.fredoka(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppColors.cardBackground,
      ),
    );
  }
}

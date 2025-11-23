import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Base Text Style (Poppins)
  static TextStyle get _poppins => GoogleFonts.poppins();

  // --- Headings ---
  static TextStyle get h1 => _poppins.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.bold, // SemiBold/Bold
  );

  static TextStyle get h2 => _poppins.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600, // Medium/SemiBold
  );

  static TextStyle get h3 => _poppins.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // --- Body Text ---
  static TextStyle get bodyLarge => _poppins.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyMedium => _poppins.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodySmall => _poppins.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // --- Button Text ---
  static TextStyle get button => _poppins.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    letterSpacing: 0.5,
  );

  // Helper untuk mendapatkan warna text sesuai tema (Light/Dark)
  static Color getPrimaryTextColor(bool isDark) =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

  static Color getSecondaryTextColor(bool isDark) =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
}
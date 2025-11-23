import 'package:flutter/material.dart';

class AppColors {
  // --- Brand Colors ---
  // PERUBAHAN: Primary Color diubah menjadi Navy Blue #09305B
  static const Color primary = Color(0xFF09305B);
  static const Color accent = Color(0xFF3F79B8);  // Teal Aksen (Tetap)

  // --- Background Colors ---
  static const Color bgLight = Color(0xFFF5F7FA); // Abu-abu sangat muda
  static const Color bgDark = Color(0xFF0F1423);  // Biru gelap (Navy)

  // --- Surface (Card/Sheet) Colors ---
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1A1F2E); // Sedikit lebih terang dari bgDark

  // --- Text Colors ---
  static const Color textPrimaryLight = Color(0xFF212121); // Hitam pekat
  static const Color textPrimaryDark = Color(0xFFF0F0F0);  // Putih terang

  static const Color textSecondaryLight = Color(0xFF37474F); // Abu-abu tua
  static const Color textSecondaryDark = Color(0xFFA0A0A0);  // Abu-abu terang

  // --- Semantic / Status Colors ---
  static const Color success = Color(0xFF4CAF50); // Hijau Profit
  static const Color error = Color(0xFFE53935);   // Merah Loss
  static const Color warning = Color(0xFFFFC107); // Kuning Peringatan

  // --- Border & Divider ---
  static const Color borderLight = Color(0xFFDADEE7);
  static const Color borderDark = Color(0xFF2A2F3E);
}
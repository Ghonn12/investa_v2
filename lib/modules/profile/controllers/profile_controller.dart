import 'package:flutter/material.dart'; // <-- PENTING: Tambahkan ini
import 'package:get/get.dart';
import '../../../../services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find();

  // Data User Reactive
  final userName = ''.obs;
  final userEmail = ''.obs;

  // State Settings
  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    // Sinkronisasi status dark mode awal
    isDarkMode.value = Get.isDarkMode;
  }

  void loadUserProfile() {
    userName.value = _authService.userName.value;
    // Jika email kosong, buat dummy dari nama
    userEmail.value = userName.value.isNotEmpty
        ? "${userName.value.replaceAll(' ', '.').toLowerCase()}@investa.com"
        : "user@investa.com";
  }

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    // ThemeMode.dark dan ThemeMode.light berasal dari material.dart
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void logout() {
    _authService.logout();
  }
}
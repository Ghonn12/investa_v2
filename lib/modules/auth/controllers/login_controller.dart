import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/auth_service.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email dan Password harus diisi", backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final success = await _authService.login(
          emailController.text,
          passwordController.text
      );

      if (success) {
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar("Login Gagal", "Periksa kembali email dan password Anda");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan koneksi");
    } finally {
      isLoading.value = false;
    }
  }
}
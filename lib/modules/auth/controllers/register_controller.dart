import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../services/auth_service.dart';
import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  void register() async {
    // Validasi Input Kosong
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
          "Form Tidak Lengkap",
          "Mohon isi nama, email, dan password.",
          backgroundColor: Colors.orange,
          colorText: Colors.white
      );
      return;
    }

    isLoading.value = true;
    try {
      final success = await _authService.register(
          nameController.text,
          emailController.text,
          passwordController.text
      );

      if (success) {
        Get.snackbar(
            "Registrasi Berhasil",
            "Akun Anda telah dibuat. Silakan login.",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 3)
        );

        // Delay sedikit agar user sempat baca notif sebelum pindah
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(Routes.LOGIN);
      }

    } on DioException catch (e) {
      log('REGISTER ERROR: ${e.response?.data}');

      String title = "Registrasi Gagal";
      String message = "Terjadi kesalahan koneksi";

      if (e.response != null) {
        final data = e.response?.data;

        // Cek pesan error dari Backend (CI4)
        if (data != null && data['messages'] != null) {
          final msgs = data['messages'];

          if (msgs is Map) {
            // Ambil pesan error pertama
            String serverMsg = msgs.values.first.toString();

            // --- LOGIKA DETEKSI EMAIL DUPLIKAT ---
            if (serverMsg.toLowerCase().contains('unique') ||
                serverMsg.toLowerCase().contains('exists') ||
                serverMsg.toLowerCase().contains('already')) {

              title = "Email Sudah Terdaftar";
              message = "Email ini sudah digunakan akun lain. Silakan Login atau gunakan email berbeda.";

            } else if (serverMsg.toLowerCase().contains('valid_email')) {
              title = "Format Email Salah";
              message = "Mohon masukkan alamat email yang valid.";
            } else {
              // Error validasi lain (misal password kurang panjang)
              message = serverMsg;
            }
          } else {
            message = msgs.toString();
          }
        } else if (data != null && data['message'] != null) {
          message = data['message'];
        }
      }

      Get.snackbar(
        title,
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );

    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan tak terduga: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // Import library Lottie
import '../controllers/splash_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/asset_paths.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // MENAMPILKAN ANIMASI LOTTIE
            // Mengambil path dari AssetPaths yang sesuai dengan struktur folder Anda
            Lottie.asset(
              AssetPaths.splashLoading, // Pastikan isinya 'assets/animations/splash_loading.json'
              width: 250,
              height: 250,
              fit: BoxFit.contain,
              // Fallback jika file tidak ditemukan atau error render
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                    Icons.bar_chart_rounded,
                    size: 100,
                    color: AppColors.primary
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              "Investa",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                letterSpacing: 2,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Your Smart Investment Partner",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryLight.withOpacity(0.7),
                fontFamily: 'Poppins',
              ),
            ),

            // Optional: Loading indicator kecil di bawah jika animasi Lottie-nya bukan tipe loading infinite
            // const SizedBox(height: 40),
            // const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input_field.dart';
import '../../../../routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Brand
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 40),
                    const SizedBox(width: 12),
                    Text(
                      "Investa",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Heading
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign in to continue your investment journey",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 40),

                // Form Input
                CustomInputField(
                  hint: "Email Address",
                  prefixIcon: Icons.email_outlined,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  hint: "Password",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller: controller.passwordController,
                ),

                const SizedBox(height: 32),

                // Tombol Login
                Obx(() => CustomButton(
                  label: "Log In",
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                )),

                const SizedBox(height: 24),

                // Navigasi ke Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : AppColors.textSecondaryLight
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.REGISTER),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
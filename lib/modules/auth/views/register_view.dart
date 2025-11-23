import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input_field.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 32),
                  const SizedBox(width: 8),
                  Text(
                    "Investa",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "Create Your Account",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Join Investa and start your investment journey today.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : AppColors.textSecondaryLight
                ),
              ),

              const SizedBox(height: 32),

              // Form
              CustomInputField(
                hint: "Full Name",
                prefixIcon: Icons.person_outline,
                controller: controller.nameController,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                hint: "Email Address",
                prefixIcon: Icons.mail_outline,
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Minimum 6 characters",
                  style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[500] : Colors.grey[600]
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Button
              Obx(() => CustomButton(
                label: "Create Account",
                isLoading: controller.isLoading.value,
                onPressed: controller.register,
              )),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                        color: isDark ? Colors.grey[400] : AppColors.textSecondaryLight
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      "Log In",
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
    );
  }
}
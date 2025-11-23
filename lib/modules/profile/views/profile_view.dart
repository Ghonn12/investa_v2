import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Helper untuk cek mode gelap saat ini
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. Avatar & User Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.primary, // Navy Blue sesuai request
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Obx(() => Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value.substring(0, 2).toUpperCase()
                            : "JD",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Text(
                    controller.userName.value.isEmpty ? "User Investa" : controller.userName.value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    controller.userEmail.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : AppColors.textSecondaryLight,
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 2. Settings Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Settings Card
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                children: [
                  // Toggle Dark Mode
                  _buildSettingItem(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: "Dark Mode",
                    trailing: Obx(() => Switch(
                      value: controller.isDarkMode.value,
                      activeColor: AppColors.primary,
                      onChanged: (val) => controller.toggleTheme(val),
                    )),
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),

                  // Currency (Static)
                  _buildSettingItem(
                    context,
                    icon: Icons.attach_money,
                    title: "Currency",
                    trailing: Row(
                      children: [
                        Text(
                          "IDR",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 4. Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                  foregroundColor: AppColors.error, // Warna teks merah
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {
    required IconData icon,
    required String title,
    required Widget trailing
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgDark : AppColors.bgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: isDark ? Colors.white : AppColors.textPrimaryLight, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Konfirmasi Logout",
      middleText: "Apakah Anda yakin ingin keluar dari akun ini?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        Get.back(); // Tutup dialog
        controller.logout();
      },
    );
  }
}
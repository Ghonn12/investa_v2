import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomInputField({
    Key? key,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ValueNotifier untuk toggle password visibility
    final obscureText = ValueNotifier<bool>(isPassword);

    return ValueListenableBuilder<bool>(
      valueListenable: obscureText,
      builder: (context, isObscured, child) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.bgDark.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isObscured,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                color: isDark ? Colors.grey[500] : AppColors.textSecondaryLight.withOpacity(0.6),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey[500],
                ),
                onPressed: () => obscureText.value = !isObscured,
              )
                  : null,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              errorStyle: const TextStyle(height: 0), // Sembunyikan pesan error default jika mau custom
            ),
          ),
        );
      },
    );
  }
}
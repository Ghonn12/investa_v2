import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finance_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input_field.dart';

class AddTransactionSheet extends GetView<FinanceController> {
  const AddTransactionSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Tambah Transaksi",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 24),

          // Toggle Type
          Obx(() => Row(
            children: [
              _buildTypeButton("Pemasukan", 'INCOME', isDark),
              const SizedBox(width: 12),
              _buildTypeButton("Pengeluaran", 'EXPENSE', isDark),
            ],
          )),

          const SizedBox(height: 24),

          // Inputs
          CustomInputField(
            hint: "Judul (misal: Gaji)",
            prefixIcon: Icons.title,
            controller: controller.titleController,
          ),
          const SizedBox(height: 16),
          CustomInputField(
            hint: "Nominal (Rp)",
            prefixIcon: Icons.attach_money,
            keyboardType: TextInputType.number,
            controller: controller.amountController,
          ),
          const SizedBox(height: 16),
          CustomInputField(
            hint: "Kategori (misal: Makan)",
            prefixIcon: Icons.category,
            controller: controller.categoryController,
          ),

          const SizedBox(height: 32),

          Obx(() => CustomButton(
            label: "Simpan Transaksi",
            isLoading: controller.isSubmitting.value,
            onPressed: controller.addTransaction,
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, String value, bool isDark) {
    final isSelected = controller.selectedType.value == value;
    final activeColor = value == 'INCOME' ? AppColors.success : AppColors.error;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedType.value = value,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : (isDark ? Colors.grey[800] : Colors.grey[100]),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeColor : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[600]),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
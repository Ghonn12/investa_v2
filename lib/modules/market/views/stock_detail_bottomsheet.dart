import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/market_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_input_field.dart';

class StockDetailBottomSheet extends GetView<MarketController> {
  final String symbol;
  final String name;
  final double price; // Price IS declared here

  const StockDetailBottomSheet({
    Key? key,
    required this.symbol,
    required this.name,
    required this.price, // Price IS required here
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 24),

          // Stock Info
          Text(symbol, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimaryLight)),
          Text(name, style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[400] : AppColors.textSecondaryLight)),
          const SizedBox(height: 12),

          // Price Display (Reactive from Controller, initialized with passed price)
          Obx(() {
            if (controller.isFetchingPrice.value) {
              return const SizedBox(
                  height: 30, width: 30,
                  child: CircularProgressIndicator(strokeWidth: 3)
              );
            }
            // Use controller value which was initialized with `price`
            return Text(
              CurrencyFormat.toIdr(controller.currentDetailPrice.value),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
            );
          }),

          const SizedBox(height: 32),

          // Input Qty
          CustomInputField(
            hint: "Jumlah Lot / Unit",
            prefixIcon: Icons.numbers,
            keyboardType: TextInputType.number,
            controller: controller.quantityController,
          ),

          const SizedBox(height: 24),

          // Actions Row
          Row(
            children: [
              // Tombol JUAL (Merah)
              Expanded(
                child: Obx(() => CustomButton(
                  label: "JUAL",
                  backgroundColor: AppColors.error,
                  isLoading: controller.isLoadingAction.value,
                  // Pass symbol & boolean isBuy=false
                  onPressed: () => controller.executeTrade(symbol, false),
                )),
              ),
              const SizedBox(width: 16),
              // Tombol BELI (Hijau/Success)
              Expanded(
                child: Obx(() => CustomButton(
                  label: "BELI",
                  backgroundColor: AppColors.success,
                  isLoading: controller.isLoadingAction.value,
                  // Pass symbol & boolean isBuy=true
                  onPressed: () => controller.executeTrade(symbol, true),
                )),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
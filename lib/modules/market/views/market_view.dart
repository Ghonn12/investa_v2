import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/market_controller.dart';
import 'stock_detail_bottomsheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_format.dart'; // Pastikan import ini ada

class MarketView extends GetView<MarketController> {
  const MarketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Market"),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        // Menggunakan list popularSymbols dari controller
        itemCount: controller.popularSymbols.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final stock = controller.popularSymbols[index];
          final symbol = stock['symbol'] as String;
          final name = stock['name'] as String;

          return GestureDetector(
            onTap: () {
              // 1. Ambil harga terakhir yang sudah di-fetch (atau 0 jika belum)
              final currentPrice = controller.stockPrices[symbol] ?? 0.0;

              // 2. Kirim data ke controller untuk persiapan BottomSheet
              controller.openTradeSheet(symbol, name, currentPrice);

              // 3. Buka BottomSheet
              Get.bottomSheet(
                StockDetailBottomSheet(
                  symbol: symbol,
                  name: name,
                  price: currentPrice, // Kirim harga awal agar langsung tampil
                ),
                isScrollControlled: true,
                backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16), // Lebih rounded (modern)
                border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight
                ),
                // Opsional: Shadow halus agar card lebih "pop"
                boxShadow: isDark ? [] : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                children: [
                  // 1. Icon Saham (Inisial)
                  CircleAvatar(
                    radius: 24, // Sedikit lebih besar
                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                    child: Text(
                      symbol[0],
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // 2. Nama & Simbol
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : AppColors.textSecondaryLight,
                            overflow: TextOverflow.ellipsis, // Cegah overflow text panjang
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),

                  // 3. HARGA SAHAM (Real-time via Obx)
                  Obx(() {
                    // Ambil harga dari map di controller
                    final price = controller.stockPrices[symbol] ?? 0.0;

                    // Jika harga masih 0 (sedang loading), tampilkan spinner kecil
                    if (price == 0) {
                      return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary
                          )
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormat.toIdr(price),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary, // Warna Navy Blue agar menonjol
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Label "Live" kecil
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4)
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.fiber_manual_record, size: 8, color: AppColors.success),
                              SizedBox(width: 4),
                              Text(
                                "Live",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
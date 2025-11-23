import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../services/trade_service.dart';
import '../../../../widgets/error_snackbar.dart';
// Import DashboardController to refresh it
import '../../dashboard/controllers/dashboard_controller.dart';

class MarketController extends GetxController {
  final TradeService _tradeService = Get.find();

  var quantityController = TextEditingController();
  var isLoadingAction = false.obs;

  // Daftar Saham Populer
  final popularSymbols = [
    {'symbol': 'BBCA.JK', 'name': 'Bank Central Asia'},
    {'symbol': 'TLKM.JK', 'name': 'Telkom Indonesia'},
    {'symbol': 'BBRI.JK', 'name': 'Bank Rakyat Indonesia'},
    {'symbol': 'BMRI.JK', 'name': 'Bank Mandiri'},
    {'symbol': 'ASII.JK', 'name': 'Astra International'},
    {'symbol': 'GOTO.JK', 'name': 'GoTo Gojek Tokopedia'},
    {'symbol': 'BTC-USD', 'name': 'Bitcoin'},
    {'symbol': 'ETH-USD', 'name': 'Ethereum'},
  ];

  // Map untuk menyimpan harga realtime per simbol
  var stockPrices = <String, double>{}.obs;

  var currentDetailPrice = 0.0.obs;
  var isFetchingPrice = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPrices();
  }

  void fetchAllPrices() async {
    for (var stock in popularSymbols) {
      final symbol = stock['symbol']!;
      try {
        final price = await _tradeService.getStockPrice(symbol);
        if (price > 0) {
          stockPrices[symbol] = price;
        }
      } catch (e) {
        log("Gagal ambil harga $symbol: $e");
      }
    }
  }

  void openTradeSheet(String symbol, String name, double initialPrice) async {
    isFetchingPrice.value = true;
    currentDetailPrice.value = initialPrice;
    quantityController.clear();

    try {
      final price = await _tradeService.getStockPrice(symbol);
      if (price > 0) {
        currentDetailPrice.value = price;
        stockPrices[symbol] = price;
      }
    } catch (e) {
      log('Error fetching detail price: $e');
    } finally {
      isFetchingPrice.value = false;
    }
  }

  double get estimatedCost {
    if (quantityController.text.isEmpty) return 0;
    final qty = double.tryParse(quantityController.text) ?? 0;
    return qty * currentDetailPrice.value;
  }

  void executeTrade(String symbol, bool isBuy) async {
    if (quantityController.text.isEmpty) {
      AppSnackbars.showError("Masukkan jumlah lot/lembar");
      return;
    }

    final qty = double.tryParse(quantityController.text);
    if (qty == null || qty <= 0) {
      AppSnackbars.showError("Jumlah harus angka positif");
      return;
    }

    isLoadingAction.value = true;
    try {
      bool success;
      log('Executing trade: $symbol, Buy: $isBuy, Qty: $qty');

      if (isBuy) {
        success = await _tradeService.buyStock(symbol, qty);
      } else {
        success = await _tradeService.sellStock(symbol, qty);
      }

      if (success) {
        AppSnackbars.showSuccess(isBuy ? "Pembelian Berhasil" : "Penjualan Berhasil");
        Get.back(); // Tutup BottomSheet
        quantityController.clear();

        // 1. Refresh harga di halaman Market ini
        fetchAllPrices();

        // 2. UPDATE DASHBOARD (Agar saldo & net worth berubah real-time)
        if (Get.isRegistered<DashboardController>()) {
          log('Refreshing Dashboard Data...');
          Get.find<DashboardController>().fetchDashboardData();
        }

      } else {
        AppSnackbars.showError("Transaksi Gagal.");
      }
    } on DioException catch (e) {
      log('DioException during trade: ${e.response?.data}');

      String message = "Terjadi kesalahan koneksi";
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data['message'] != null) {
          message = data['message'].toString();
        } else if (data['messages'] != null) {
          if (data['messages'] is Map) {
            message = data['messages'].values.first.toString();
          } else {
            message = data['messages'].toString();
          }
        } else if (data['error'] != null) {
          message = data['error'].toString();
        }
      }
      AppSnackbars.showError(message);

    } catch (e) {
      log('Unknown error during trade: $e');
      AppSnackbars.showError("Gagal: ${e.toString()}");
    } finally {
      isLoadingAction.value = false;
    }
  }
}
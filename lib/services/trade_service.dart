import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'api_service.dart';
import '../core/values/api_constants.dart';
import '../models/portfolio_model.dart';

class TradeService extends GetxService {
  final ApiService _api = Get.find();

  // Mengambil data portfolio lengkap dengan Net Worth & PnL
  // 1. Fetch Portfolio (Saldo & Aset User)
  Future<Map<String, dynamic>> getPortfolioOverview() async {
    try {
      final response = await _api.get(ApiConstants.portfolio);
      if (response.statusCode == 200) {
        final data = response.data['data'];

        final List holdingsRaw = data['holdings'] ?? [];
        final holdings = holdingsRaw.map((e) => PortfolioModel.fromJson(e)).toList();

        return {
          'cash_balance': double.parse(data['cash_balance'].toString()),
          'portfolio_value': double.parse(data['portfolio_value'].toString()),
          'net_worth': double.parse(data['net_worth'].toString()),
          'holdings': holdings,
        };
      }
      throw Exception("Failed to load portfolio");
    } catch (e) {
      log('Error fetching portfolio: $e');
      rethrow;
    }
  }

  // 2. Fetch Market Stocks (Daftar Saham Populer + Harga) -- INI YANG PENTING
  Future<List<Map<String, dynamic>>> getMarketStocks() async {
    try {
      // Pastikan URL ini benar: /api/market/stocks
      final response = await _api.get(ApiConstants.marketStocks);

      log("Market API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // JSON Struktur: { "data": [ {symbol: "...", price: 8400}, ... ] }
        final List rawList = response.data['data'];

        log("Market Data Count: ${rawList.length}");

        return List<Map<String, dynamic>>.from(rawList);
      }
      return [];
    } catch (e) {
      log('Error fetching market stocks: $e');
      return []; // Return kosong biar gak crash, tapi cek log console
    }
  }

  // 3. Buy Stock
  Future<bool> buyStock(String symbol, double quantity) async {
    try {
      final response = await _api.post(ApiConstants.tradeBuy, data: {
        'symbol': symbol,
        'quantity': quantity,
      });
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  // 4. Sell Stock
  Future<bool> sellStock(String symbol, double quantity) async {
    try {
      final response = await _api.post(ApiConstants.tradeSell, data: {
        'symbol': symbol,
        'quantity': quantity,
      });
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  // 5. Get Single Price (Untuk Detail BottomSheet)
  Future<double> getStockPrice(String symbol) async {
    try {
      final response = await _api.get(ApiConstants.marketPrice, params: {'symbol': symbol});
      if (response.statusCode == 200 && response.data['data'] != null) {
        return double.tryParse(response.data['data']['price'].toString()) ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}
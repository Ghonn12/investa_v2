import 'dart:developer'; // Import log
import 'package:get/get.dart';
import '../../../../services/trade_service.dart';
import '../../../../services/auth_service.dart';

class DashboardController extends GetxController {
  final TradeService _tradeService = Get.find();
  final AuthService _authService = Get.find();

  var isLoading = true.obs;
  var netWorth = 0.0.obs;
  var cashBalance = 0.0.obs;
  var userName = ''.obs;

  // List baru untuk Market Movers (Data Asli)
  var marketMovers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    userName.value = _authService.userName.value;
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    try {
      // 1. Ambil Data Portfolio (Net Worth)
      final portfolioData = await _tradeService.getPortfolioOverview();
      netWorth.value = double.tryParse(portfolioData['net_worth'].toString()) ?? 0.0;
      cashBalance.value = double.tryParse(portfolioData['cash_balance'].toString()) ?? 0.0;

      // 2. Ambil Data Saham Populer (Market Movers)
      final stocksData = await _tradeService.getMarketStocks();

      // Ambil 5 saham teratas saja untuk ditampilkan di Home
      marketMovers.assignAll(stocksData.take(5).toList());

    } catch (e) {
      log("Error fetching dashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
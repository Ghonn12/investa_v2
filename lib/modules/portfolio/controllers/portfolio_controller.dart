import 'package:get/get.dart';
import '../../../../services/trade_service.dart';
import '../../../../models/portfolio_model.dart';

class PortfolioController extends GetxController {
  final TradeService _tradeService = Get.find();

  var isLoading = true.obs;
  var cashBalance = 0.0.obs;
  var totalInvested = 0.0.obs;
  var netWorth = 0.0.obs;
  var holdings = <PortfolioModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPortfolio();
  }

  void fetchPortfolio() async {
    try {
      isLoading.value = true;
      final data = await _tradeService.getPortfolioOverview();

      cashBalance.value = data['cash_balance'];
      totalInvested.value = data['portfolio_value'];
      netWorth.value = data['net_worth'];
      holdings.assignAll(data['holdings']);

    } catch (e) {
      // print("Error portfolio: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
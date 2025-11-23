class PortfolioModel {
  final int id;
  final String symbol;
  final double quantity;
  final double averagePrice;
  final double currentPrice; // Harga real-time (di-enrich oleh controller)
  final double pnl;          // Profit/Loss Nominal
  final double pnlPercent;   // Profit/Loss Persen

  PortfolioModel({
    required this.id,
    required this.symbol,
    required this.quantity,
    required this.averagePrice,
    this.currentPrice = 0.0,
    this.pnl = 0.0,
    this.pnlPercent = 0.0,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: int.parse(json['id'].toString()),
      symbol: json['symbol'] ?? '',
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      averagePrice: double.tryParse(json['average_price'].toString()) ?? 0.0,
      // Field di bawah ini mungkin null jika data mentah dari DB lokal
      currentPrice: double.tryParse(json['current_price']?.toString() ?? '0') ?? 0.0,
      pnl: double.tryParse(json['pnl']?.toString() ?? '0') ?? 0.0,
      pnlPercent: double.tryParse(json['pnl_percent']?.toString() ?? '0') ?? 0.0,
    );
  }
}
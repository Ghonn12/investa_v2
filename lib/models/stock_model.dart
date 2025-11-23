class StockModel {
  final String symbol;
  final double price;
  final double changePercent; // Opsional, jika API mendukung

  StockModel({
    required this.symbol,
    required this.price,
    this.changePercent = 0.0,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'] ?? '',
      price: double.tryParse(json['regularMarketPrice'].toString()) ?? 0.0,
      // changePercent bisa ditambahkan jika API response punya field ini
    );
  }
}
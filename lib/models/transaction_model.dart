class TransactionModel {
  final int id;
  final String title;
  final double amount;
  final String type; // INCOME / EXPENSE
  final String category;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? 'No Title',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      type: json['type'] ?? 'EXPENSE',
      category: json['category'] ?? 'General',
      date: DateTime.parse(json['date']),
    );
  }

  bool get isIncome => type == 'INCOME';
}
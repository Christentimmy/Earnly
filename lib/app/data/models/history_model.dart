class HistoryModel {
  final String type;
  final num amount;
  final num balanceBefore;
  final num balanceAfter;
  final dynamic meta;
  final DateTime createdAt;
  final DateTime updatedAt;

  HistoryModel({
    required this.type,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json){
    return HistoryModel(
      type: json['type'] ?? "",
      amount: num.tryParse(json['amount'].toString()) ?? 0.0,
      balanceBefore: num.tryParse(json['balanceBefore'].toString()) ?? 0.0,
      balanceAfter: num.tryParse(json['balanceAfter'].toString()) ?? 0.0,
      meta: json['meta'] ?? {},
      createdAt: DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now(),
    );
  }
}

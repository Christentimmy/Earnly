class WithdrawModel {
  final double amount;
  final String status;
  final PaymentDetails paymentDetails;
  final DateTime createdAt;

  WithdrawModel({
    required this.amount,
    required this.status,
    required this.paymentDetails,
    required this.createdAt,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) {
    return WithdrawModel(
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status'] ?? "",
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails'] ?? {}),
      createdAt:
          DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now(),
    );
  }
}

class PaymentDetails {
  final String network;
  final String memo;
  final String walletAddress;

  PaymentDetails({
    required this.network,
    required this.memo,
    required this.walletAddress,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      network: json['network'] ?? "",
      memo: json['memo'] ?? "",
      walletAddress: json['walletAddress'] ?? "",
    );
  }
}

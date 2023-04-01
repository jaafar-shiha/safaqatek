import 'package:safaqtek/models/Payment/transaction_data.dart';

class PaymentData {
  PaymentData({
    required this.transactionData,
  });

  TransactionData transactionData;

  PaymentData copyWith({
    TransactionData? transactionData,
  }) =>
      PaymentData(
        transactionData: transactionData ?? this.transactionData,
      );

  factory PaymentData.fromMap(Map<String, dynamic> json) => PaymentData(
    transactionData: TransactionData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "data": transactionData.toMap(),
  };
}


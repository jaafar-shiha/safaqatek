
import 'package:safaqtek/models/Coupons/coupon.dart';
import 'package:safaqtek/models/Payment/cart.dart';

class TransactionData {
  TransactionData({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.createdAt,
    required this.cart,
    required this.coupons,
  });

  String transactionId;
  int amount;
  String currency;
  String createdAt;
  List<Cart> cart;
  List<Coupon> coupons;

  TransactionData copyWith({
    String? transactionId,
    int? amount,
    String? currency,
    String? createdAt,
    List<Cart>? cart,
    List<Coupon>? coupons,
  }) =>
      TransactionData(
        transactionId: transactionId ?? this.transactionId,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        createdAt: createdAt ?? this.createdAt,
        cart: cart ?? this.cart,
        coupons: coupons ?? this.coupons,
      );

  factory TransactionData.fromMap(Map<String, dynamic> json) => TransactionData(
    transactionId: json["transaction_id"],
    amount: json["amount"],
    currency: json["currency"],
    createdAt: json["created_at"],
    cart: List<Cart>.from(json["cart"].map((x) => Cart.fromMap(x))),
    coupons: List<Coupon>.from(json["coupons"].map((x) => Coupon.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "transaction_id": transactionId,
    "amount": amount,
    "currency": currency,
    "created_at": createdAt,
    "cart": List<dynamic>.from(cart.map((x) => x.toMap())),
    "coupons": List<dynamic>.from(coupons.map((x) => x.toMap())),
  };
}
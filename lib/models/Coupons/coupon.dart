import 'package:safaqtek/models/Coupons/coupon_product.dart';

class Coupon {
  Coupon({
    required this.key,
    required this.participateWith,
    required this.createdAt,
    required this.product,
     this.isWinner = false,
  });

  String key;
  String participateWith;
  String createdAt;
  CouponProduct product;
  bool? isWinner;

  Coupon copyWith({
    String? key,
    String? participateWith,
    String? createdAt,
    CouponProduct? product,
    bool? isWinner,
  }) =>
      Coupon(
        key: key ?? this.key,
        participateWith: participateWith ?? this.participateWith,
        createdAt: createdAt ?? this.createdAt,
        product: product ?? this.product,
        isWinner: isWinner ?? this.isWinner,
      );

  factory Coupon.fromMap(Map<String, dynamic> json) => Coupon(
    key: json["key"],
    participateWith: json["participate_with"],
    createdAt: json["created_at"],
    isWinner: json["isWinner"],
    product: CouponProduct.fromMap(json["product"]),
  );

  Map<String, dynamic> toMap() => {
    "key": key,
    "participate_with": participateWith,
    "created_at": createdAt,
    "isWinner": isWinner,
    "product": product.toMap(),
  };
}

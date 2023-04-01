import 'package:safaqtek/models/Payment/reusable_cart_data.dart';

class ReusableCart {
  ReusableCart({
    required this.id,
    required this.object,
    required this.cartData,
  });

  String id;
  String object;
  ReusableCartData cartData;

  ReusableCart copyWith({
    String? id,
    String? object,
    ReusableCartData? cartData,
  }) =>
      ReusableCart(
        id: id ?? this.id,
        object: object ?? this.object,
        cartData: cartData ?? this.cartData,
      );

  factory ReusableCart.fromMap(Map<String, dynamic> json) => ReusableCart(
    id: json["id"],
    object: json["object"],
    cartData: ReusableCartData.fromMap(json["card"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "object": object,
    "card": cartData.toMap(),
  };
}
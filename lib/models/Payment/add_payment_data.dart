import 'package:safaqtek/models/Payment/add_cart.dart';

class AddPaymentData {
  AddPaymentData({
    required this.amount,
    required this.paymentId,
    required this.cart,
    required this.isDonate,
    required this.latitude,
    required this.longitude,
  });

  int amount;
  String paymentId;
  List<AddCart> cart;
  bool isDonate;
  String latitude;
  String longitude;


  Map<String, dynamic> toMap() => {
    "amount": amount,
    "payment_id": paymentId,
    "cart": '${cart.map((e) => e.toMap()).toList()}'.toString(),
    "isDonate": isDonate,
    "lat": latitude,
    "lng": longitude,
  };
}


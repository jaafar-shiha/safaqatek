import 'package:safaqtek/models/Coupons/coupon.dart';

class CouponsData {
  CouponsData({
    required this.data,
  });

  List<Coupon> data;


  factory CouponsData.fromMap(Map<String, dynamic> json) => CouponsData(
    data: List<Coupon>.from(json["data"].map((x) => Coupon.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };

  CouponsData copyWith({
    List<Coupon>? data,
  }) =>
      CouponsData(
        data: data ?? this.data,
      );
}

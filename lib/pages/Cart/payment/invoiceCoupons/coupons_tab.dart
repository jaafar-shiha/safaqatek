import 'package:flutter/material.dart';
import 'package:safaqtek/models/Coupons/coupon.dart';
import 'package:safaqtek/widgets/coupon_card.dart';

class CouponsTab extends StatefulWidget {
  final List<Coupon> coupons;
  const CouponsTab({Key? key, required this.coupons}) : super(key: key);

  @override
  _CouponsTabState createState() => _CouponsTabState();
}

class _CouponsTabState extends State<CouponsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.coupons.map((coupon) => CouponCard(coupon: coupon,)).toList(),
    );
  }
}

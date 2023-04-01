import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Coupons/coupon.dart';
import 'package:safaqtek/widgets/coupon_card.dart';

class CouponsListWidget extends StatefulWidget {
  final List<Coupon> coupons;

  const CouponsListWidget({Key? key, required this.coupons}) : super(key: key);

  @override
  _CouponsListWidgetState createState() => _CouponsListWidgetState();
}

class _CouponsListWidgetState extends State<CouponsListWidget> {

  late final List<Coupon> filteredCoupons = widget.coupons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8.0),
              child: Text(
                S.of(context).recentlyBoughtFirst,
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.gunPowder,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            ...widget.coupons.map((coupon) => CouponCard(coupon: coupon,))
          ],
        ),
      ),
    );
  }
}

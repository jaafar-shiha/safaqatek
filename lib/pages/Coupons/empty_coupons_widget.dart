import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/generated/l10n.dart';

class EmptyCouponsWidget extends StatelessWidget {
  const EmptyCouponsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                S.of(context).yourCouponsAreEmpty,
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.dirtyPurple,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/empty_coupons.png'),
          ),
        ),

      ],
    );
  }
}

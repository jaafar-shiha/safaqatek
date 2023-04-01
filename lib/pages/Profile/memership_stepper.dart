import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';

class MembershipStepper extends StatelessWidget {
  const MembershipStepper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Image.asset(
                'assets/images/bronze.png',
                height: 25,
              ),
            ),
            Text(
              S.of(context).bronze,
              style: AppStyles.h4.copyWith(
                color: AppColors.whiteLilac,
              ),
            ),
          ],
        ),
        Expanded(
          child: Divider(
            color: AppColors.gray,
            thickness: 2,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Image.asset(
                'assets/images/silver.png',
                height: 25,
              ),
            ),
            Text(
              S.of(context).silver,
              style: AppStyles.h4.copyWith(
                color: AppColors.whiteLilac,
              ),
            ),
          ],
        ),
        Expanded(
          child: Divider(
            color: AppColors.gray,
            thickness: 2,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Image.asset(
                'assets/images/gold.png',
                height: 25,
              ),
            ),
            Text(
              S.of(context).goldy,
              style: AppStyles.h4.copyWith(
                color: AppColors.whiteLilac,
              ),
            ),
          ],
        ),
        Expanded(
          child: Divider(
            color: AppColors.gray,
            thickness: 2,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Image.asset(
                'assets/images/platinum.png',
                height: 25,
              ),
            ),
            Text(
              S.of(context).platinum,
              style: AppStyles.h4.copyWith(
                color: AppColors.whiteLilac,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

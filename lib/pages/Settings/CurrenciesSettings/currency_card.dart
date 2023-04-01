import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';

class CurrencyCard extends StatelessWidget {
  final String code;
  final String flagImagePath;
  final Function() onTap;
  final bool isSelected;

  const CurrencyCard({
    Key? key,
    required this.code,
    required this.flagImagePath,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 4.0, right: 10.0, left: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(flagImagePath, height: 30, width: 30),
                    const SizedBox(width: 10),
                    Text(
                      code,
                      style: AppStyles.h2,
                    ),
                  ],
                ),
                if (isSelected)
                  Image.asset(
                    'assets/images/check-circle.png',
                    height: 20,
                  ),
              ],
            ),
            Divider(height: 1.3, color: AppColors.lightGray),
          ],
        ),
      ),
    );
  }
}

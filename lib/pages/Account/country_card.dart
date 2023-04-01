import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/models/Setttings/country.dart';

class CountryCard extends StatelessWidget {
  final Country country;
  final Function() onTap;
  const CountryCard({Key? key, required this.country, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(country.name,style: TextStyle(
              fontSize: 18,
              color: AppColors.gunPowder,
              letterSpacing: 1.2,
            ),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(height: 1.3, color: AppColors.lightGray),
            ),
          ],
        ),
      ),
    );
  }
}

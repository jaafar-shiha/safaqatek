import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';

class ImageSliderShimmer extends StatelessWidget {
  const ImageSliderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        right: 8.0,
        bottom: 15.0
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              spreadRadius: 2.5,
              color: Colors.grey[350]!,
              blurRadius: 6,
              offset: const Offset(1, 7), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}

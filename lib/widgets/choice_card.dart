import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';

class ChoiceCard extends StatelessWidget {
  final String title;
  final bool isSelected;

  const ChoiceCard({Key? key, required this.title, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isSelected ? AppColors.dirtyPurple : AppColors.gray,
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: AppColors.whiteLilac,
                  size: 18,
                )
              : const SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: AppStyles.h2.copyWith(
              color: isSelected ? AppColors.dirtyPurple : AppColors.gray,
            ),
          ),
        ),
      ],
    );
  }
}

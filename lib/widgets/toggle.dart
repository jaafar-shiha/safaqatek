import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';

class Toggle extends StatelessWidget {
  final bool isActivated;
  final String? title;
  final ValueChanged<bool> onChanged;
  final Color? textColor;

  const Toggle(
      {Key? key, required this.onChanged,
        this.textColor ,
        this.isActivated = false,
        this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Transform.scale(
          scale: 1.3,
          child: Switch(
            activeColor: AppColors.dirtyPurple,
            value: isActivated,
            onChanged: onChanged,
          ),
        ),
        if (title != null)
          Expanded(
              child: Text(title!,
                  style: AppStyles.h3.copyWith(
                    color: textColor??AppColors.gunPowder,
                  ),
                  softWrap: true)),
      ],
    );
  }
}

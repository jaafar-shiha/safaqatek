import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';

class OptionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final Function() onTap;
  const OptionCard({Key? key, required this.iconPath, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Image.asset(iconPath, height: 26,color: AppColors.dirtyPurple),
              title: Text(title),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.gunPowder,
                size: 22,
              ),
            ),
            Divider(height: 1.3, color: AppColors.lightGray),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';

class MainTabBarIcon extends StatelessWidget {
  final String title;
  final String imagePath;
  final Function() onPressed;
  final bool isSelected;
  final bool showNotification;
  final int numberInNotification;

  const MainTabBarIcon({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
    required this.isSelected,
    this.showNotification = false,
    this.numberInNotification = 0,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Color _tabBarIconColor = isSelected ? AppColors.dirtyPurple : AppColors.gray;
    return Expanded(
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  imagePath,
                  width: 25,
                  height: 25,
                  color: _tabBarIconColor,
                ),
                if (showNotification && numberInNotification != 0)
                Positioned(
                  top: -10,
                  right: -7,
                  child: CircleAvatar(
                    backgroundColor: AppColors.dirtyPurple,
                    child: Text(
                      '$numberInNotification',
                      style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                    ),
                    radius: 10,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: TextStyle(fontSize: 8.5, color: _tabBarIconColor, fontWeight: FontWeight.w700),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/levels_enum.dart';
import 'package:safaqtek/generated/l10n.dart';

class LevelCard extends StatelessWidget {
  final Levels level;
  final bool isActive;
  final String message;

  const LevelCard({
    Key? key,
    required this.level,
    required this.isActive,
    required this.message,
  }) : super(key: key);

  Color getFontColor(Levels level) {
    switch (level) {
      case Levels.bronze:
        return AppColors.brownishOrange;
      case Levels.silver:
        return AppColors.frenchGrey;
      case Levels.gold:
        return AppColors.dirtyYellow;
      case Levels.platinum:
        return AppColors.brownSugar;
      default:
        return AppColors.frenchGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteLilac,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    level.getString(),
                    style: TextStyle(
                      fontSize: 22,
                      color: getFontColor(level),
                      letterSpacing: 1,
                    ),
                  ),
                  if (isActive)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.dirtyPurple,
                            AppColors.royalFuchsia,
                            AppColors.royalFuchsia,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.whiteLilac,
                              radius: 6,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              S.of(context).active,
                              style: AppStyles.h3.copyWith(
                                color: AppColors.whiteLilac,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 35,
              ),
              Divider(
                color: AppColors.lightGray,
                thickness: 2,
              ),
              Text(
                message,
                style: AppStyles.h2.copyWith(
                  color: getFontColor(level),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

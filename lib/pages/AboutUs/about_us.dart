import 'package:flutter/material.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.whiteLilac,
                      ),
                    ),
                    Text(
                      S.of(context).aboutUS,
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.whiteLilac,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  locator<MainApp>().appSettings!.data.setting.about,
                  style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                ),
              ),
            ],
          ),
        ));
  }
}

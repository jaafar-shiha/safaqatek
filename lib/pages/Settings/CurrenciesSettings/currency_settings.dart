import 'package:flutter/material.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/currencies_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';

class CurrencySettings extends StatelessWidget {
  final Function() onTap;
  final String currentCurrency;
   CurrencySettings({Key? key, required this.onTap, required this.currentCurrency}) : super(key: key);

  final ValueNotifier<Currencies> selectedCurrency = ValueNotifier(Currencies.aed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.whiteLilac,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).currency,
                style: AppStyles.h2,
              ),
              Text(
                locator<MainApp>().currentUser!.currency?.toUpperCase()??'AED',
                style: AppStyles.h2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';

class AppDialog {

  static AlertDialog showAlertDialog({required String title,
    Widget? content,
    required List<Widget> actions,
    MainAxisAlignment actionsAlignment = MainAxisAlignment.end}) {
    return AlertDialog(
      actionsAlignment: actionsAlignment,
      content: content,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      title: Text(title, style: AppStyles.h2,),
      actions: actions,
    );
  }

  static AlertDialog showOptionDialog({required List<Widget> options,}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) =>
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                option,
                if(option != options.last)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1.3, color: AppColors.lightGray),
                  ),
              ],
            )).toList(),
      ),
    );
  }
}
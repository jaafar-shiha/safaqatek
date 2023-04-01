import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';

class AppFlushBar {

  static Flushbar showFlushbar({required String message}){

    return Flushbar(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      duration: const Duration(seconds: 2),
      messageText: Text(
        message,
        style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
        textAlign: TextAlign.center,
      ),
      backgroundColor: AppColors.gunPowder.withOpacity(0.7),
      borderRadius: BorderRadius.circular(25),
    );
  }
}
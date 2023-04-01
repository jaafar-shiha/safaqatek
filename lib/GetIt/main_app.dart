import 'package:flutter/material.dart';
import 'package:safaqtek/models/Setttings/settings_data.dart';
import 'package:safaqtek/models/User/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainApp {
  String? token;
  User? currentUser;
  Locale? language;
  BuildContext? context;
  SettingsData? appSettings;
  SharedPreferences? sharedPreferences;

  MainApp({
    this.token,
    this.currentUser,
    this.language,
    this.context,
    this.appSettings,
  })  {
    init();
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();

  }
}


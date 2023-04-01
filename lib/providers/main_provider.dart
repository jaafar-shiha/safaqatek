import 'package:flutter/material.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';

class MainProvider with ChangeNotifier {
  Locale? _language;

  Locale? get language => _language;

  bool _refreshProductsList = false;

  String? _profileUrl;
  String? get profileUrl => _profileUrl;

  void setProfileUrl(String? url){
    _profileUrl = url;
    notifyListeners();
  }

  bool get refreshProductsList => _refreshProductsList;
   void refresh({required bool value}){
    _refreshProductsList = value;
    notifyListeners();
  }

  void changeLanguage(Locale locale) {
    S.load(locale);
    //1 _prefs!.setString('languageCode', locale.languageCode);
    locator<MainApp>().sharedPreferences!.setString('languageCode', locale.languageCode);
    _language = locale;
    locator<MainApp>().language = Locale(locale.languageCode);
    notifyListeners();
  }

  Future initPrefs() async {
    //1 _prefs = await SharedPreferences.getInstance();
    //1 if (_prefs!.getString('languageCode') != null) {
    if (locator<MainApp>().sharedPreferences?.getString('languageCode') != null) {
      //1 _language = Locale(_prefs!.getString('languageCode')!);
      _language = Locale(locator<MainApp>().sharedPreferences!.getString('languageCode')!);
      //1 locator<MainApp>().language = Locale(_prefs!.getString('languageCode')!);
      locator<MainApp>().language = Locale(locator<MainApp>().sharedPreferences!.getString('languageCode')!);
    }
    else{
      //1 _prefs!.setString('languageCode', Localizations.localeOf(locator<MainApp>().context!).languageCode);
      try{
        locator<MainApp>().language = Locale(Localizations?.localeOf(locator<MainApp>().context!).languageCode);
      }
      catch(_){
        locator<MainApp>().language = const Locale('en');
      }
    }
  }
}

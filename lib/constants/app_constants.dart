
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/locator.dart';

class AppConstants{

  final String baseUrl = 'https://safaqatek.com';

  static String supportPhoneNumber = locator<MainApp>.call().appSettings!.data.setting.supportPhone;
  static String privacyPolicyUrl = 'https://www.safaqatek.com/pages/privacy-policy.html';
  static String termsAndConditionsUrl = 'https://www.safaqatek.com/pages/terms-and-conditions.html';


}
import 'package:get_it/get_it.dart';
import 'package:safaqtek/GetIt/main_app.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  MainApp mainApp = MainApp();
  locator.registerSingleton<MainApp>(mainApp);
}

import 'dart:async';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Products/product.dart';
import 'package:safaqtek/models/Products/products_data.dart';
import 'package:safaqtek/models/Setttings/settings_data.dart';
import 'package:safaqtek/models/User/user_data.dart';
import 'package:safaqtek/pages/LogIn/log_in_page.dart';
import 'package:safaqtek/pages/ProductsList/ProductPage/product_page.dart';
import 'package:safaqtek/pages/home_page.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/services/products_services.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> initSharedPreferences() async {
    await Provider.of<MainProvider>(context, listen: false).initPrefs();
  }

  ProductsServices productsServices = ProductsServices();
  SettingsServices settingsServices = SettingsServices();
  AuthenticationServices authenticationServices = AuthenticationServices();

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      final Uri deepLink = dynamicLinkData.link;
      int id = int.parse(deepLink.toString().substring(deepLink.toString().lastIndexOf('/') + 1));
      await productsServices.getProduct(id: id).then((value) {
        if (value is SuccessState<ProductsData>) {
          Product product = value.data.products.first;
          Navigator.of(locator<MainApp>().context!)
              .push(MaterialPageRoute(builder: (context) => ProductPage(product: product)));
        } else if (value is ErrorState<ProductsData>) {
          AppFlushBar.showFlushbar(message: value.error.error).show(context);
        }
      });
    }).onError((e) {
      AppFlushBar.showFlushbar(message: e).show(context);
    });
  }

  Future<void> initSettings() async {
    await settingsServices.getSettings().then((settings) {
      if (settings is SuccessState<SettingsData>) {
        locator<MainApp>().appSettings = settings.data;
      } else if (settings is ErrorState<SettingsData>) {
        if (mounted){
          AppFlushBar.showFlushbar(message: settings.error.error).show(context);
        }
      }
    });
  }

  Future<void> initApp() async {
    DateTime startTime = DateTime.now();
      await initSharedPreferences();

      if (locator<MainApp>().sharedPreferences?.getBool('isLoggedIn') ?? false) {
        locator<MainApp>().token = locator<MainApp>().sharedPreferences!.getString('token')!;
          await authenticationServices.getUserProfile(token: locator<MainApp>().token!).then((responseState) async {
            if (responseState is SuccessState<UserData>) {
              locator<MainApp>().currentUser = responseState.data.user;
            } else if (responseState is ErrorState<UserData>) {
              AppFlushBar.showFlushbar(message: responseState.error.error).show(context);
              await initSettings();
              DateTime endTime = DateTime.now();
              int processingSeconds = (endTime.difference(startTime).inSeconds).round();
              while (processingSeconds < 6) {
                processingSeconds++;
                await Future.delayed(const Duration(seconds: 1));
              }
              if (locator<MainApp>().appSettings == null) {
                return;
              }
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LogInPage(),
                ),
              );
              initDynamicLinks();
              return;
            }
            if (locator<MainApp>().currentUser != null) {
              locator<MainApp>().sharedPreferences!.setString('languageCode', locator<MainApp>().currentUser!.lang!);
              locator<MainApp>().language = Locale(locator<MainApp>().currentUser!.lang!);
              Provider.of<MainProvider>(context, listen: false)
                  .changeLanguage(Locale(locator<MainApp>().currentUser!.lang!));
              Provider.of<MainProvider>(context, listen: false).setProfileUrl(locator<MainApp>().currentUser?.avatar);
            }
            await initSettings();
            DateTime endTime = DateTime.now();
            int processingSeconds = (endTime.difference(startTime).inSeconds).round();
            while (processingSeconds < 6) {
              processingSeconds++;
              await Future.delayed(const Duration(seconds: 1));
            }
            if (locator<MainApp>().currentUser == null || locator<MainApp>().appSettings == null) {
              AppFlushBar.showFlushbar(message: S.of(context).unknownError).show(context);
              initDynamicLinks();
              return;
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          });

      }
      else {
        await initSettings();
        DateTime endTime = DateTime.now();
        int processingSeconds = (endTime.difference(startTime).inSeconds).round();
        while (processingSeconds < 6) {
          processingSeconds++;
          await Future.delayed(const Duration(seconds: 1));
        }
        if (locator<MainApp>().appSettings == null) {
          return;
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LogInPage(),
          ),
        );
      }
    initDynamicLinks();
  }

  @override
  void initState() {
    initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        }
        if (Platform.isIOS) {
          exit(0);
        }
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFB61E4),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              'assets/images/safaqatek.gif',
            )),
          ],
        ),
      ),
    );
  }
}

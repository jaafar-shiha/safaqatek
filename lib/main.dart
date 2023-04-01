import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/blocs/CouponsBloc/coupons_bloc.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_bloc.dart';
import 'package:safaqtek/blocs/PaymentBloc/payment_bloc.dart';
import 'package:safaqtek/blocs/ProductsBloc/products_bloc.dart';
import 'package:safaqtek/blocs/SettingsBloc/settigns_bloc.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_bloc.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:device_preview/device_preview.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/pages/splash_page.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/services/fcm_services.dart';

import 'GetIt/main_app.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print('A bg message just showed up :  ${message.messageId}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FCMServices fcmServices = FCMServices();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await setupLocator();
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabsProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => CartProductsProvider()),
      ],
      child: DevicePreview(
        enabled: false, //
        tools: const [
          ...DevicePreview.defaultTools,
        ],
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LogInBloc>(
          create: (context) => LogInBloc(),
        ),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(),
        ),
        BlocProvider<ProductsBloc>(
          create: (context) => ProductsBloc(),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => PaymentBloc(),
        ),
        BlocProvider<CouponsBloc>(
          create: (context) => CouponsBloc(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
      ],
      child: Consumer<MainProvider>(
        builder: (context, mainProvider, _){
          locator<MainApp>().context = context;
          return MaterialApp(
            title: S().safaqatek,
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            // builder: DevicePreview.appBuilder,
            supportedLocales: S.delegate.supportedLocales,
            locale: locator<MainApp>().sharedPreferences?.getString('languageCode') != null
                ? Locale(locator<MainApp>().sharedPreferences!.getString('languageCode')!) : mainProvider.language,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: AppColors.dirtyPurple,
                  secondary: AppColors.dirtyPurple,
                ),
                textTheme: TextTheme(
                  bodyText1: AppStyles.h1,
                ),
                fontFamily: (locator<MainApp>().language?.languageCode??'en') == 'ar' ? 'CairoSemiBold' : 'PoppinsSemiBold'
            ),
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}

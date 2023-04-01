import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_bloc.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_event.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/text_field_type.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Authentication/log_in.dart';
import 'package:safaqtek/models/Authentication/register_model.dart';
import 'package:safaqtek/models/Setttings/settings_data.dart';
import 'package:safaqtek/models/User/user.dart';
import 'package:safaqtek/pages/home_page.dart';
import 'package:safaqtek/pages/LogIn/ForgotPasswordBottomSheet/forgot_password_bottom_sheet.dart';
import 'package:safaqtek/pages/SignUp/sign_up_page.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/services/connectivity_services.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/custom_container_clipper.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:safaqtek/widgets/text_field_widget.dart';

class LogInPage extends StatefulWidget {
  final bool isFromGuestPage;
  const LogInPage({Key? key, this.isFromGuestPage = false}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late final LogInBloc _logInBloc = BlocProvider.of<LogInBloc>(context);

  final RoundedLoadingButtonController logInBtnController = RoundedLoadingButtonController();

  String emailOrPhoneNumber = '';
  String password = '';

  late ConnectivityServices connectivityServices;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  final SettingsServices _settingsServices = SettingsServices();
  @override
  void initState() {
    connectivityServices = ConnectivityServices(onConnectivityChanged: (isNotConnected) {
      if (mounted) {
        AppFlushBar.showFlushbar(
          message:
              isNotConnected ? S.of(context).noInternetConnection : S.of(context).internetConnectionHasBeenRestored,
        ).show(context);
      }
    });

    initConnectivity();
    super.initState();
  }

  initConnectivity() async {
    await connectivityServices.initConnectivityServices();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void saveUserData({
    required User user,
  }) {
    locator<MainApp>().sharedPreferences!.setBool('isLoggedIn', true);
    locator<MainApp>().sharedPreferences!.setString(
        'user',
        jsonEncode(user,
            toEncodable: (Object? value) =>
                value is User ? value.toMap() : throw UnsupportedError('Cannot convert to JSON: $value')));
  }

  @override
  Widget build(BuildContext context) {locator<MainApp>().context = context;
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
      child: BlocListener<LogInBloc, LoginState>(
        bloc: _logInBloc,
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) async {
          if (state is LogInFailed) {
            logInBtnController.reset();
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          } else if (state is LogInSucceeded) {
            //1 Provider.of<MainProvider>(context, listen: false).prefs!.setString('token', state.registrationToken.token);
            locator<MainApp>().sharedPreferences!.setString('token', state.registrationToken.token);
            _logInBloc.add(GetUserProfile(token: state.registrationToken.token));
            locator<MainApp>().token = state.registrationToken.token;

          } else if (state is LogInWithGoogleSucceeded) {
            logInBtnController.reset();
            if (state.googleSignInAccount != null) {
              isLoading.value = true;
              _logInBloc.add(CheckIfEmailRegister(state.googleSignInAccount!));
            }
          } else if (state is LogInWithGoogleFailed) {
            logInBtnController.reset();
            isLoading.value = false;
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          } else if (state is UserNotRegistered) {
            logInBtnController.reset();
            //Note: isLoading.value still true.
            _logInBloc.add(RegisterUserForFirstTime(RegisterModel(
                email: state.googleSignInAccount.email,
                firstName: state.googleSignInAccount.displayName ?? S.of(context).user,
                lastName: '',
                password: state.googleSignInAccount.id,
                phone: '')));
          } else if (state is UserAlreadyRegistered) {
            logInBtnController.reset();
            _logInBloc.add(LogIn(
                logInModel: LogInModel(
              emailOrPhoneNumber: state.googleSignInAccount.email,
              password: state.googleSignInAccount.id,
            )));
          } else if (state is RegisterUserForFirstTimeSucceeded) {
            logInBtnController.reset();
            locator<MainApp>().token = state.registrationToken.token;
            _logInBloc.add(GetUserProfile(token: state.registrationToken.token));
          } else if (state is RegisterUserForFirstTimeFailed) {
            logInBtnController.reset();
            isLoading.value = false;
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          } else if (state is GettingUserPhoneNumberFailed) {
            logInBtnController.reset();
            isLoading.value = false;
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          } else if (state is GetUserProfileSucceeded)  {

            isLoading.value = false;
            saveUserData(user: state.user);
            locator<MainApp>().currentUser = state.user;
            locator<MainApp>().language = Locale(state.user.lang??'en');
            locator<MainApp>().sharedPreferences!.setString('languageCode', locator<MainApp>().currentUser!.lang!);
            locator<MainApp>().language = Locale(locator<MainApp>().currentUser!.lang!);
            Provider.of<MainProvider>(context,listen: false).changeLanguage(Locale(locator<MainApp>().currentUser!.lang!));
            Provider.of<MainProvider>(context,listen: false).setProfileUrl(locator<MainApp>().currentUser?.avatar);

            await _settingsServices.getSettings().then((newSettingsDate) {
              if (newSettingsDate is SuccessState<SettingsData>){
                locator<MainApp>().appSettings = newSettingsDate.data;
              }
              else if (newSettingsDate is ErrorState<SettingsData>){
                AppFlushBar.showFlushbar(message: newSettingsDate.error.error).show(context);
              }
            });
            logInBtnController.reset();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          } else if (state is GetUserProfileFailed) {
            logInBtnController.reset();
            isLoading.value = false;
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          }
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, val, child) {
            return ModalProgressHUD(
              inAsyncCall: isLoading.value,
              progressIndicator: CircularProgressIndicator(
                color: AppColors.dirtyPurple,
              ),
              child: MainScaffold(
                body: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).logIn,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15.0,
                          bottom: 15.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  _logInBloc.add(const LogInWithGooglePressed());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(),
                                    Text(
                                      S.of(context).logInWithGoogle,
                                      style: AppStyles.h2,
                                    ),
                                    Image.asset(
                                      'assets/images/google.png',
                                      height: 35,
                                    ),
                                  ],
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.whiteLilac),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //TODO: Apple
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     left: 15,
                      //     right: 15.0,
                      //     bottom: 15.0,
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextButton(
                      //           onPressed: () async {},
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //             children: [
                      //               const SizedBox(),
                      //               Text(
                      //                 S.of(context).logInWithApple,
                      //                 style: AppStyles.h2,
                      //               ),
                      //               Image.asset(
                      //                 'assets/images/apple.png',
                      //                 height: 35,
                      //               ),
                      //             ],
                      //           ),
                      //           style: ButtonStyle(
                      //             backgroundColor: MaterialStateProperty.all<Color>(AppColors.whiteLilac),
                      //             shape: MaterialStateProperty.all<OutlinedBorder>(
                      //               RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(30),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Expanded(
                        child: ClipPath(
                          clipper: CustomContainerClipper(),
                          child: Container(
                            color: AppColors.whiteLilac,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4.0,
                                        bottom: 30.0,
                                      ),
                                      child: Center(
                                        child: Text(
                                          S.of(context).orLoginWithEmail,
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: AppColors.gunPowder,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFieldWidget(
                                      labelText: S.of(context).emailOrPhoneNumber,
                                      iconPath: 'assets/images/username.png',
                                      textFieldType: TextFieldType.username,
                                      onChanged: (value) {
                                        emailOrPhoneNumber = value;
                                      },
                                    ),
                                    TextFieldWidget(
                                      labelText: S.of(context).password,
                                      iconPath: 'assets/images/password.png',
                                      textFieldType: TextFieldType.password,
                                      onChanged: (value) {
                                        password = value;
                                      },
                                      obscureText: true,
                                      suffixIcon: TextButton(
                                        onPressed: () {
                                          showMaterialModalBottomSheet(
                                            context: context,
                                            useRootNavigator: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) {
                                              return SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.65,
                                                  child: const ForgotPasswordBottomSheet());
                                            },
                                          );
                                        },
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                        ),
                                        child: Text(
                                          S.of(context).forgot,
                                          style: AppStyles.h2.copyWith(color: AppColors.frenchBlue),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 15.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RoundedLoadingButton(
                                              onPressed: () async {
                                                if (emailOrPhoneNumber == '' || password == '') {
                                                  logInBtnController.reset();
                                                  AppFlushBar.showFlushbar(
                                                    message: S.of(context).pleaseFillAllRequiredFields,
                                                  ).show(context);
                                                  return;
                                                }
                                                _logInBloc.add(LogIn(
                                                  logInModel: LogInModel(
                                                    emailOrPhoneNumber: emailOrPhoneNumber,
                                                    password: password,
                                                  ),
                                                ));
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                child: Text(
                                                  S.of(context).logIn,
                                                  style: AppStyles.h2.copyWith(color: Colors.white),
                                                ),
                                              ),
                                              color: AppColors.frenchBlue,
                                              controller: logInBtnController,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text.rich(
                                          TextSpan(
                                              text: S.of(context).dontHaveAnAccount,
                                              style: AppStyles.h2,
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: ' ${S.of(context).signUp}',
                                                  style: AppStyles.h2.copyWith(
                                                    color: AppColors.frenchBlue,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => const SignUpPage(),
                                                        ),
                                                      );
                                                    },
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Center(
                                        child: Text.rich(
                                          TextSpan(
                                              text: S.of(context).orContinueAs,
                                              style: AppStyles.h2,
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: ' ${S.of(context).aGuest}',
                                                  style: AppStyles.h2.copyWith(
                                                    color: AppColors.frenchBlue,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                    if (widget.isFromGuestPage){
                                                      Navigator.of(context).pop();
                                                      return ;
                                                    }
                                                      locator<MainApp>().sharedPreferences!.setBool('isLoggedIn', false);
                                                      locator<MainApp>().sharedPreferences!.remove('user');
                                                      locator<MainApp>().sharedPreferences!.remove('token');
                                                      locator<MainApp>().currentUser = null;
                                                      locator<MainApp>().token = null;
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => const HomePage(),
                                                        ),
                                                      );
                                                    },
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

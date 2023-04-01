import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_bloc.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_event.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Authentication/register_model.dart';
import 'package:safaqtek/models/Setttings/country.dart';
import 'package:safaqtek/models/Setttings/settings_data.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';
import 'package:safaqtek/models/User/user.dart';
import 'package:safaqtek/models/base_success_response.dart';
import 'package:safaqtek/pages/home_page.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:otp_text_field/otp_text_field.dart';

class VerifyingPage extends StatefulWidget {
  final String verificationId;
  final RegisterModel registerModel;
  final PhoneNumber phoneNumber;

  const VerifyingPage({
    Key? key,
    required this.verificationId,
    required this.registerModel,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _VerifyingPageState createState() => _VerifyingPageState();
}

class _VerifyingPageState extends State<VerifyingPage> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  String smsCode = '';

  late final SignUpBloc _signUpBloc = BlocProvider.of<SignUpBloc>(context);

  final SettingsServices _settingsServices = SettingsServices();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      bloc: _signUpBloc,
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) async {
        if (state is VerifyNumberSucceeded) {
          _signUpBloc.add(SignUp(registerModel: widget.registerModel));
        } else if (state is VerifyNumberFailed) {
          _btnController.reset();
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        } else if (state is SignUpSucceeded) {
          locator<MainApp>().token = state.token.token;
          locator<MainApp>().sharedPreferences!.setString('token', state.token.token);
          await _settingsServices.getSettings().then((newSettingsDate) {
            if (newSettingsDate is SuccessState<SettingsData>) {
              locator<MainApp>().appSettings = newSettingsDate.data;
            } else if (newSettingsDate is ErrorState<SettingsData>) {
              AppFlushBar.showFlushbar(message: newSettingsDate.error.error).show(context);
            }
          });
          _signUpBloc.add(GetUserProfile(token: state.token.token));
        } else if (state is SigningUpFailed) {
          _btnController.reset();
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        } else if (state is GetUserProfileSucceeded) {
          locator<MainApp>().currentUser = state.user;
          Country country = locator<MainApp>().appSettings!.data.countries.singleWhere(
                (element) => '+${element.dialCode}' == widget.phoneNumber.countryCode,
              );
          await _settingsServices
              .updateUserProfile(
            updateUserProfile: UpdateUserProfile(
              residenceId: country.id,
            ),
          )
              .then((value) {
            _btnController.reset();
            if (value is SuccessState<BaseSuccessResponse>) {
              locator<MainApp>().currentUser!.residence = country.name;

            } else if (value is ErrorState<BaseSuccessResponse>) {
              AppFlushBar.showFlushbar(message: value.error.error).show(context);
            }
          });
          locator<MainApp>().sharedPreferences!.setBool('isLoggedIn', true);
          locator<MainApp>().sharedPreferences!.setString('languageCode', locator<MainApp>().currentUser!.lang!);
          locator<MainApp>().language = Locale(locator<MainApp>().currentUser!.lang!);
          Provider.of<MainProvider>(context, listen: false)
              .changeLanguage(Locale(locator<MainApp>().currentUser!.lang!));
          Provider.of<MainProvider>(context, listen: false).setProfileUrl(locator<MainApp>().currentUser?.avatar);
          locator<MainApp>().sharedPreferences!.setString(
              'user',
              jsonEncode(state.user,
                  toEncodable: (Object? value) =>
                      value is User ? value.toMap() : throw UnsupportedError('Cannot convert to JSON: $value')));
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else if (state is GetUserProfileFailed) {
          _btnController.reset();
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        }
      },
      child: MainScaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.whiteLilac,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  S.of(context).gettingStarted,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.whiteLilac,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  S.of(context).createAnAccountToContinue,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.whiteLilac,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.whiteLilac,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).enterYourOTPCodeHere,
                            style: AppStyles.h2.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OTPTextField(
                                  length: 6,
                                  style: AppStyles.textFieldLabel,
                                  textFieldAlignment: MainAxisAlignment.spaceAround,
                                  fieldStyle: FieldStyle.underline,
                                  onChanged: (code) {
                                    smsCode = code;
                                  },
                                  otpFieldStyle: OtpFieldStyle(
                                    focusBorderColor: AppColors.dirtyPurple,
                                  ),
                                  onCompleted: (code) {
                                    smsCode = code;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RoundedLoadingButton(
                                    onPressed: () async {
                                      if (smsCode.length < 6) {
                                        _btnController.reset();
                                        AppFlushBar.showFlushbar(message: S.of(context).pleaseEnterAuthenticationCode)
                                            .show(context);
                                        return;
                                      }
                                      _signUpBloc.add(
                                        VerifyNumber(
                                          verificationId: widget.verificationId,
                                          smsCode: smsCode,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(
                                        S.of(context).next,
                                        style: AppStyles.h2.copyWith(color: Colors.white),
                                      ),
                                    ),
                                    color: AppColors.frenchBlue,
                                    controller: _btnController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

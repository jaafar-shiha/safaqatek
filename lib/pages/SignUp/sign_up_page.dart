import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_constants.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/text_field_type.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Authentication/phone_number_success_response.dart';
import 'package:safaqtek/models/Authentication/register_model.dart';
import 'package:safaqtek/models/Authentication/user_phone_number.dart';
import 'package:safaqtek/pages/SignUp/number_verification_page.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/custom_container_clipper.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:safaqtek/widgets/phone_number_widget.dart';
import 'package:safaqtek/widgets/text_field_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  PhoneNumber? phoneNumber;
  bool agreeToTermsAndConditions = false;


  bool isEmailTaken = false;
  RegisterModel? registerModel;
  Country? selectedCountry;
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  final AuthenticationServices _authenticationServices =AuthenticationServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.whiteLilac,
                      ),
                    ),
                    Text(
                      S.of(context).signUp,
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldWidget(
                                  labelText: S.of(context).firstName,
                                  iconPath: 'assets/images/username.png',
                                  textFieldType: TextFieldType.username,
                                  onChanged: (value) {
                                    firstName = value;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFieldWidget(
                                  labelText: S.of(context).lastName,
                                  iconPath: 'assets/images/username.png',
                                  textFieldType: TextFieldType.username,
                                  onChanged: (value) {
                                    lastName = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextFieldWidget(
                            labelText: S.of(context).email,
                            iconPath: 'assets/images/email.png',
                            textInputType: TextInputType.emailAddress,
                            textFieldType: TextFieldType.email,
                            isValid: !isEmailTaken,
                            onChanged: (value) {
                              email = value;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              S.of(context).phoneNumber,
                              style: AppStyles.h2.copyWith(color: AppColors.gray),
                            ),
                          ),
                          PhoneNumberWidget(
                            onSelect: (
                              number,
                            ) {
                              phoneNumber = number;
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
                          ),
                          TextFieldWidget(
                            labelText: S.of(context).confirmPassword,
                            iconPath: 'assets/images/password.png',
                            textFieldType: TextFieldType.password,
                            onChanged: (value) {
                              confirmPassword = value;
                            },
                            obscureText: true,
                          ),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text.rich(
                              TextSpan(text: S.of(context).IAgreeTo, style: AppStyles.h3, children: <InlineSpan>[
                                TextSpan(
                                  text: ' ${S.of(context).termsAndConditions}',
                                  style: AppStyles.h3
                                      .copyWith(color: AppColors.dirtyPurple, decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                    launchUrl(Uri.parse(AppConstants.termsAndConditionsUrl));
                                    },
                                ),
                                TextSpan(
                                  text: ' ${S.of(context).and} ',
                                  style: AppStyles.h3,
                                ),
                                TextSpan(
                                  text: S.of(context).privacyPolicy,
                                  style: AppStyles.h3
                                      .copyWith(color: AppColors.dirtyPurple, decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    launchUrl(Uri.parse(AppConstants.privacyPolicyUrl));
                                  },
                                ),
                              ]),
                            ),
                            value: agreeToTermsAndConditions,
                            activeColor: AppColors.dirtyPurple,
                            onChanged: (newValue) {
                              setState(() {
                                agreeToTermsAndConditions = !agreeToTermsAndConditions;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
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
                                      if (password != confirmPassword) {
                                        _btnController.reset();
                                        AppFlushBar.showFlushbar(
                                          message: S.of(context).passwordsMismatch,
                                        ).show(context);
                                        return;
                                      }
                                      if (firstName.isEmpty ||
                                          lastName.isEmpty ||
                                          email.isEmpty ||
                                          password.isEmpty ||
                                          confirmPassword.isEmpty ||
                                          phoneNumber == null || !agreeToTermsAndConditions) {
                                        _btnController.reset();
                                        AppFlushBar.showFlushbar(
                                          message: S.of(context).pleaseFillAllRequiredFields,
                                        ).show(context);
                                        return;
                                      }
                                      registerModel = RegisterModel(
                                          firstName: firstName,
                                          lastName: lastName,
                                          email: email,
                                          password: password,
                                          phone: phoneNumber!.completeNumber);
                                      await _authenticationServices.getAccountPhoneNumber(email: email).then((value) async {
                                        _btnController.reset();
                                        if (value is SuccessState<UserPhoneNumber>) {
                                          setState(() {
                                            isEmailTaken = true;
                                          });
                                          AppFlushBar.showFlushbar(message: S.of(context).emailHasBeenTaken).show(context);
                                          return;
                                        } else if (value is ErrorState<UserPhoneNumber>) {
                                          await _authenticationServices.checkIfPhoneTaken(phoneNumber: phoneNumber!.completeNumber).then((value) {
                                            if (value is SuccessState<PhoneNumberSuccessResponse>){
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => NumberVerificationPage(
                                                    phoneNumber: phoneNumber!,
                                                    registerModel: registerModel!,
                                                  ),
                                                ),
                                              );
                                            }
                                            else if (value is ErrorState<PhoneNumberSuccessResponse>){
                                              AppFlushBar.showFlushbar(message: value.error.error).show(context);
                                            }
                                          });
                                        }
                                      });


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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

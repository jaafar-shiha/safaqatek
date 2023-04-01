import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_bloc.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_event.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/text_field_type.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/text_field_widget.dart';

class NewPasswordSection extends StatefulWidget {
  final Function(String,String,String) onMovingToNextSection;

  const NewPasswordSection({Key? key, required this.onMovingToNextSection}) : super(key: key);

  @override
  State<NewPasswordSection> createState() => _NewPasswordSectionState();
}

class _NewPasswordSectionState extends State<NewPasswordSection> {
  String email = '';

  String newPassword = '';

  String confirmNewPassword = '';

  final RoundedLoadingButtonController saveBtnController = RoundedLoadingButtonController();

  late final LogInBloc _logInBloc = BlocProvider.of<LogInBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogInBloc, LoginState>(
      bloc: _logInBloc,
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is GettingUserPhoneNumberSucceeded) {
          _logInBloc.add(SendOTPCode(phoneNumber: state.phoneNumber));
        } else if (state is GettingUserPhoneNumberFailed) {
          saveBtnController.reset();
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        } else if (state is SendOTPSucceeded) {
          saveBtnController.reset();
          widget.onMovingToNextSection(state.verificationId,newPassword,email);
        } else if (state is SendOTPFailed) {
        saveBtnController.reset();
        AppFlushBar.showFlushbar(message: state.error.error).show(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    S.of(context).typeYourNewPassword,
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.gunPowder,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldWidget(
                        labelText: S.of(context).email,
                        iconPath: 'assets/images/email.png',
                        textFieldType: TextFieldType.email,
                        textInputType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      TextFieldWidget(
                        labelText: S.of(context).newPassword,
                        iconPath: 'assets/images/password.png',
                        textFieldType: TextFieldType.password,
                        onChanged: (value) {
                          newPassword = value;
                        },
                        obscureText: true,
                      ),
                      TextFieldWidget(
                        labelText: S.of(context).confirmNewPassword,
                        iconPath: 'assets/images/password.png',
                        textFieldType: TextFieldType.password,
                        onChanged: (value) {
                          confirmNewPassword = value;
                        },
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 25.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: RoundedLoadingButton(
                                onPressed: () async {
                                  if (email == '' || newPassword == '' || confirmNewPassword == '') {
                                    saveBtnController.reset();
                                    AppFlushBar.showFlushbar(
                                      message: S.of(context).pleaseFillAllRequiredFields,
                                    ).show(context);
                                    return;
                                  }
                                  if (newPassword != confirmNewPassword) {
                                    saveBtnController.reset();
                                    AppFlushBar.showFlushbar(
                                      message: S.of(context).passwordsMismatch,
                                    ).show(context);
                                    return;
                                  }
                                  _logInBloc.add(GetAccountPhoneNumber(email: email));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    S.of(context).save,
                                    style: AppStyles.h2.copyWith(color: Colors.white),
                                  ),
                                ),
                                color: AppColors.frenchBlue,
                                controller: saveBtnController,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

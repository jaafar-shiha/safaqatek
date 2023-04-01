import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_bloc.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_event.dart';
import 'package:safaqtek/blocs/LogInBloc/log_in_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';

class VerifyingNumberSection extends StatefulWidget {
  final String email;
  final String verificationId;
  final String newPassword;

  const VerifyingNumberSection(
      {Key? key, required this.verificationId, required this.newPassword, required this.email,})
      : super(key: key);

  @override
  _VerifyingNumberSectionState createState() => _VerifyingNumberSectionState();
}

class _VerifyingNumberSectionState extends State<VerifyingNumberSection> {
  String smsCode = '';

  final RoundedLoadingButtonController saveBtnController = RoundedLoadingButtonController();

  late final LogInBloc _logInBloc = BlocProvider.of<LogInBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogInBloc, LoginState>(
      bloc: _logInBloc,
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state)  {
        if (state is VerifyNumberFailed) {
          saveBtnController.reset();
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        } else if (state is VerifyNumberSucceeded) {
          _logInBloc.add(ChangeAccountPassword(newPassword: widget.newPassword,email: widget.email));
        } else if (state is ChangingAccountPasswordSucceeded) {
          saveBtnController.reset();
          Navigator.pop(context);
          AppFlushBar.showFlushbar(message: S.of(context).passwordChangedSuccessfully).show(context);
        } else if (state is ChangingAccountPasswordFailed) {
          saveBtnController.reset();
          AppFlushBar.showFlushbar(message: state.error.error).show(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  S.of(context).enterYourOTPCodeHere,
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
                  children: [
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
                        vertical: 25.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RoundedLoadingButton(
                              onPressed: () async {

                                if (smsCode == '') {
                                  saveBtnController.reset();
                                  AppFlushBar.showFlushbar(
                                    message: S.of(context).pleaseEnterAuthenticationCode,
                                  ).show(context);
                                  return;
                                }
                                _logInBloc.add(VerifyNumber(smsCode: smsCode, verificationId: widget.verificationId));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  S.of(context).next,
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
            )
          ],
        ),
      ),
    );
  }
}

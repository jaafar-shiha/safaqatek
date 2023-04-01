import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_bloc.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_event.dart';
import 'package:safaqtek/blocs/SignUpBloc/sign_up_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/models/Authentication/register_model.dart';
import 'package:safaqtek/pages/SignUp/verifying_page.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/widgets/phone_number_widget.dart';

class NumberVerificationPage extends StatefulWidget {
  final PhoneNumber phoneNumber;
  final RegisterModel registerModel;

  const NumberVerificationPage({
    Key? key,
    required this.phoneNumber,
    required this.registerModel,
  }) : super(key: key);

  @override
  _NumberVerificationPageState createState() => _NumberVerificationPageState();
}

class _NumberVerificationPageState extends State<NumberVerificationPage> {
  late PhoneNumber phoneNumber = widget.phoneNumber;

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  TextEditingController phoneController = TextEditingController();
  late final SignUpBloc _signUpBloc = BlocProvider.of<SignUpBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      bloc: _signUpBloc,
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is SendOTPFailed) {
          _btnController.reset();
          AppFlushBar.showFlushbar(message: state.error.error,).show(context);
        }
        if (state is SendOTPSucceeded) {
          _btnController.reset();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => VerifyingPage(
                      verificationId: state.verificationId,
                  registerModel: widget.registerModel,
                  phoneNumber: widget.phoneNumber,
                    )),
          );
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
                            S.of(context).otpAuthentication,
                            style: AppStyles.h2.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                          PhoneNumberWidget(
                            phoneNumber: widget.phoneNumber,
                            onSelect: (
                              number,
                            ) {
                              phoneNumber = number!;
                            },
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
                                      _signUpBloc.add(
                                        SendOTPCode(
                                          phoneNumber: phoneNumber.completeNumber,
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

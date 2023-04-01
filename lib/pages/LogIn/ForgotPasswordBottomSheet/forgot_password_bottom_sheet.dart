import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/forgot_password_bottom_sheet_sections.dart';
import 'package:safaqtek/pages/LogIn/ForgotPasswordBottomSheet/new_password_section.dart';
import 'package:safaqtek/pages/LogIn/ForgotPasswordBottomSheet/verifying_number_section.dart';

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordBottomSheetState createState() => _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  ValueNotifier<ForgotPasswordBottomSheetSections> currentSection =
      ValueNotifier(ForgotPasswordBottomSheetSections.assignNewPassword);

  String? verificationID;
  String? newPassword;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteLilac,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25),
        ),
      ),
      child: ValueListenableBuilder<ForgotPasswordBottomSheetSections>(
        valueListenable: currentSection,
        builder: (context, val, child) {
          switch (currentSection.value) {
            case ForgotPasswordBottomSheetSections.assignNewPassword:
              return NewPasswordSection(
                onMovingToNextSection: (verificationId, password,emailValue) {
                  verificationID = verificationId;
                  newPassword = password;
                  currentSection.value = ForgotPasswordBottomSheetSections.verifyingNumber;
                  email = emailValue;
                },
              );
            case ForgotPasswordBottomSheetSections.verifyingNumber:
              return VerifyingNumberSection(
                verificationId: verificationID!,
                newPassword: newPassword!,
                email: email!,
              );
            default:
              return NewPasswordSection(
                onMovingToNextSection: (verificationId, password,emailValue) {
                  verificationID = verificationId;
                  newPassword = password;
                  currentSection.value = ForgotPasswordBottomSheetSections.verifyingNumber;
                  email = emailValue;
                },
              );
          }
        },
      ),
    );
  }
}

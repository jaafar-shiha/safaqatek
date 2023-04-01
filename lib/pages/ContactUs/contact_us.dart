import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/text_field_type.dart';
import 'package:safaqtek/constants/validators.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  String subject = '';
  String emailAddress = '';
  String inquiry = '';

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }


  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, '');
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.whiteLilac,
                    ),
                  ),
                  Text(
                    S.of(context).contactUs,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                S
                    .of(context)
                    .fillOutTheFormBelowToContactTheDevelopersForYourConcernsRegardingTheApplicationOfTheCompany,
                style: AppStyles.h3.copyWith(color: AppColors.whiteLilac),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: TextField(
                style: AppStyles.h2.copyWith(color: AppColors.gunPowder),
                decoration: InputDecoration(
                  fillColor: AppColors.whiteLilac,
                  filled: true,
                  hintText: S.of(context).subject,
                  hintStyle: AppStyles.h2.copyWith(color: AppColors.gunPowder),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  subject = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: TextField(
                style: AppStyles.h2.copyWith(color: AppColors.gunPowder),
                decoration: InputDecoration(
                  fillColor: AppColors.whiteLilac,
                  filled: true,
                  hintText: S.of(context).emailAddress,
                  hintStyle: AppStyles.h2.copyWith(color: AppColors.gunPowder),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  emailAddress = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: TextField(
                style: AppStyles.h2.copyWith(color: AppColors.gunPowder),
                maxLines: 10,
                decoration: InputDecoration(
                  fillColor: AppColors.whiteLilac,
                  filled: true,
                  hintMaxLines: 17,
                  hintText: S.of(context).yourInquiry,
                  hintStyle: AppStyles.h2.copyWith(color: AppColors.gunPowder),
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  inquiry = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
              child: RoundedLoadingButton(
                width: double.maxFinite,
                loaderStrokeWidth: 2.0,
                onPressed: () async {
                  if (!Validators.isValidForm(TextFieldType.email, emailAddress)) {
                    _btnController.reset();
                    AppFlushBar.showFlushbar(
                      message: S.of(context).pleaseFillAllRequiredFields,
                    ).show(context);
                    return;
                  }
                    final Email email = Email(
                      body: inquiry,
                      subject: subject,
                      recipients: ['gaafar.ger@gmail.com'],
                      isHTML: false,
                    );

                  try {
                    await FlutterEmailSender.send(email);
                    _btnController.reset();
                  } catch (error) {
                    _btnController.reset();
                    AppFlushBar.showFlushbar(message: error.toString()).show(context);
                  }

                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Text(
                    S.of(context).sendMessage,
                    style: AppStyles.h2.copyWith(color: Colors.white),
                  ),
                ),
                color: AppColors.frenchBlue,
                controller: _btnController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    ));
  }
}

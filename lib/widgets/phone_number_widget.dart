import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/validators.dart';

class PhoneNumberWidget extends StatefulWidget {
  final PhoneNumber? phoneNumber;
  final Function(PhoneNumber?) onSelect;

  const PhoneNumberWidget({Key? key, required this.onSelect, this.phoneNumber}) : super(key: key);

  @override
  _PhoneNumberWidgetState createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  late ValueNotifier<PhoneNumber> phoneNumber = ValueNotifier(
    widget.phoneNumber ?? PhoneNumber(countryCode: '', countryISOCode: '', number: ''),
  );


  late Country selectedCountry = widget.phoneNumber  == null ? const Country(
    name: "United Arab Emirates",
    flag: "🇦🇪",
    code: "AE",
    dialCode: "971",
    minLength: 9,
    maxLength: 9,
  ) : countries.singleWhere((element) => element.code == widget.phoneNumber!.countryISOCode);

  late TextEditingController phoneNumberController = TextEditingController(text: widget.phoneNumber?.number);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ValueListenableBuilder<PhoneNumber>(
        valueListenable: phoneNumber,
        builder: (context, val, child) {
          return IntlPhoneField(
            onChanged: (value) {
              phoneNumber.value = value;
              if (phoneNumber.value.number.length != selectedCountry.maxLength) {
                widget.onSelect(null);
              } else {
                widget.onSelect(phoneNumber.value);
              }
            },
            onCountryChanged: (country) {
              selectedCountry = country;
              phoneNumber.value = PhoneNumber(countryCode: country.dialCode, countryISOCode: country.code, number: '');
              phoneNumberController.clear();
              widget.onSelect(null,);
            },
            countries: const ['AE','BH','OM','QA','KW','SA'],//locator<MainApp>().appSettings!.data.countries.map((e) => e.name).toList()
            controller: phoneNumberController,
            dropdownIconPosition: IconPosition.trailing,
            initialCountryCode: widget.phoneNumber?.countryISOCode ?? selectedCountry.code,
            style: AppStyles.textFieldLabel,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: AppColors.ferrariRed,
              )),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: phoneNumber.value.number.isEmpty ? AppColors.gray : AppColors.darkMintGreen,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Validators.isPhoneNumberValid(phoneNumber: phoneNumber.value, selectedCountry: selectedCountry)
                    ? AppColors.darkMintGreen
                    : AppColors.ferrariRed,
              )),
              suffix: Validators.isPhoneNumberValid(phoneNumber: phoneNumber.value, selectedCountry: selectedCountry)
                  ? Icon(
                      Icons.check,
                      color: AppColors.darkMintGreen,
                    )
                  : Icon(
                      Icons.close_rounded,
                      color: AppColors.ferrariRed,
                    ),
            ),
          );
        },
      ),
    );
  }
}

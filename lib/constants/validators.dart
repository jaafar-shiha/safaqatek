import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:safaqtek/constants/text_field_type.dart';
import 'package:regexpattern/regexpattern.dart';

class Validators{
  static bool isValidForm(TextFieldType textFieldType, String value){
    switch (textFieldType) {
      case TextFieldType.username:
        return value.isNotEmpty;
      case TextFieldType.none:
        return true;
      case TextFieldType.email:
        return value.isEmail();
      case TextFieldType.phone:
        return value.isPhone();
      case TextFieldType.password:
        return value.isPasswordEasy();
      default:
        return true;
    }
  }

  static bool isPhoneNumberValid({required PhoneNumber phoneNumber,required Country selectedCountry}){
    return phoneNumber.completeNumber.isPhone() && selectedCountry.maxLength == phoneNumber.number.length;
  }
}
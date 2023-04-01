import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/SettingsBloc/settigns_bloc.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_event.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/gender_enum.dart';
import 'package:safaqtek/constants/text_field_type.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Authentication/phone_number_success_response.dart';
import 'package:safaqtek/models/Setttings/country.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';
import 'package:safaqtek/models/User/user.dart';
import 'package:safaqtek/pages/Account/address_page.dart';
import 'package:safaqtek/pages/Account/countries_page.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/choice_card.dart';
import 'package:safaqtek/widgets/custom_container_clipper.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:safaqtek/widgets/phone_number_widget.dart';
import 'package:safaqtek/widgets/text_field_widget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late String firstName = locator<MainApp>().currentUser!.firstName;
  late String lastName = locator<MainApp>().currentUser!.lastName;
  String email = locator<MainApp>().currentUser!.email;
  late PhoneNumber phone = initPhoneNumber();

  final AuthenticationServices _authenticationServices = AuthenticationServices();
  final ValueNotifier<Country> countryOfResidence = ValueNotifier(locator<MainApp>()
      .appSettings!
      .data
      .countries
      .singleWhere((element) => element.name == locator<MainApp>().currentUser!.residence, orElse: () {
    return locator<MainApp>().appSettings!.data.countries.first;
  }));
  String address = locator<MainApp>().currentUser!.addresse ?? '';

  ValueNotifier<Gender> gender = ValueNotifier(
    locator<MainApp>().currentUser!.sex?.toLowerCase() == 'male' ? Gender.male : Gender.female,
  );
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  PhoneNumber initPhoneNumber() {
    if (locator<MainApp>().currentUser!.phone == null) {
      return PhoneNumber(countryISOCode: 'AE', countryCode: '971', number: '');
    }
    Country countryOfPhoneNumber = locator<MainApp>().appSettings!.data.countries.singleWhere(
        (element) => locator<MainApp>().currentUser!.phone!.startsWith('+${element.dialCode}'), orElse: () {
      return locator<MainApp>().appSettings!.data.countries.first;
    });
    String countryCode = '+${countryOfPhoneNumber.dialCode}';
    String countryISOCode = countryOfPhoneNumber.code;
    String phoneNumber = locator<MainApp>().currentUser!.phone!.substring(
          locator<MainApp>().currentUser!.phone!.indexOf(countryCode) + countryCode.length,
        );
    return PhoneNumber(countryISOCode: countryISOCode, countryCode: countryCode, number: phoneNumber);
  }

  late final SettingsBloc _settingsBloc = BlocProvider.of<SettingsBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        _btnController.reset();
        if (state is UpdateUserProfileSucceeded) {
          Navigator.of(context).pop();
          AppFlushBar.showFlushbar(message: state.baseSuccessResponse.message).show(context);
        }
        if (state is UpdateUserProfileFailed) {
          AppFlushBar.showFlushbar(message: state.baseErrorResponse.error).show(context);
        }
      },
      bloc: _settingsBloc,
      listenWhen: (prev, cur) {
        return prev != cur;
      },
      child: MainScaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
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
                        S.of(context).personalDetails,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipPath(
                      clipper: CustomContainerClipper(borderRadius: 40, onlyFromTopEdges: false),
                      child: Container(
                        color: AppColors.whiteLilac,

                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
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
                                        initialValue: firstName,
                                        onChanged: (value) {
                                          firstName = value;
                                        },
                                      ),
                                    ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                      child: TextFieldWidget(
                                        labelText: S.of(context).lastName,
                                        iconPath: 'assets/images/username.png',
                                        textFieldType: TextFieldType.username,
                                        initialValue: lastName,
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
                                  textFieldType: TextFieldType.email,
                                  initialValue: email,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: PhoneNumberWidget(
                                    phoneNumber: phone,
                                    onSelect: (
                                      number,
                                    ) {
                                      if (number != null) {
                                        phone = number;
                                      }
                                    },
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: gender,
                                  builder: (context, val, child) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            gender.value = Gender.male;
                                          },
                                          child: ChoiceCard(
                                            title: S.of(context).male,
                                            isSelected: gender.value == Gender.male,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            gender.value = Gender.female;
                                          },
                                          child: ChoiceCard(
                                            title: S.of(context).female,
                                            isSelected: gender.value == Gender.female,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      int? countryId = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CountriesPage(),
                                        ),
                                      );
                                      if (countryId != null) {
                                        countryOfResidence.value = locator<MainApp>()
                                            .appSettings!
                                            .data
                                            .countries
                                            .singleWhere((element) => element.id == countryId);
                                      }
                                      if (countryId != null) {
                                        address = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const AddressPage(),
                                          ),
                                        );
                                      }
                                    },
                                    child: ValueListenableBuilder<Country>(
                                      valueListenable: countryOfResidence,
                                      builder: (context, value, child) {
                                        return TextFieldWidget(
                                          labelText: S.of(context).countryOfResidence,
                                          iconPath: 'assets/images/nationality.png',
                                          textFieldType: TextFieldType.none,
                                          isEnabled: false,
                                          initialValue: countryOfResidence.value.name,
                                          onChanged: (value) {},
                                          suffixIcon: Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColors.gunPowder,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 15,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RoundedLoadingButton(
                                          onPressed: () async {
                                            if (firstName == '' ||
                                                lastName == '' ||
                                                email == '' ||
                                                phone.completeNumber.length <= 5) {
                                              _btnController.reset();
                                              AppFlushBar.showFlushbar(message: S().pleaseFillAllRequiredFields)
                                                  .show(context);
                                              return;
                                            } else {
                                              await _authenticationServices.checkIfPhoneTaken(phoneNumber: phone.completeNumber).then((value) {
                                                if (value is SuccessState<PhoneNumberSuccessResponse> ||
                                                    locator<MainApp>().currentUser!.phone == phone.completeNumber
                                                ){
                                                  _settingsBloc.add(UpdateProfile(
                                                    updateUserProfile: UpdateUserProfile(
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      email: email == locator<MainApp>().currentUser!.email ? null : email,
                                                      addresse: address == '' ? null : address,
                                                      residenceId: countryOfResidence.value.id,
                                                      phone: phone.completeNumber,
                                                      sex: gender.value.convertToString(),
                                                    ),
                                                  ));
                                                  locator<MainApp>().currentUser!.email = email;
                                                  locator<MainApp>().currentUser!.firstName = firstName;
                                                  locator<MainApp>().currentUser!.lastName = lastName;
                                                  locator<MainApp>().currentUser!.addresse = address;
                                                  locator<MainApp>().currentUser!.residence = countryOfResidence.value.name;
                                                  locator<MainApp>().currentUser!.phone = phone.completeNumber;
                                                  locator<MainApp>().currentUser!.sex = gender.value.convertToString();
                                                  locator<MainApp>().sharedPreferences!.setString(
                                                      'user',
                                                      jsonEncode(locator<MainApp>().currentUser!,
                                                          toEncodable: (Object? value) =>
                                                          value is User ? value.toMap() : throw UnsupportedError('Cannot convert to JSON: $value')));
                                                }
                                                else if (value is ErrorState<PhoneNumberSuccessResponse>){
                                                  _btnController.reset();
                                                  AppFlushBar.showFlushbar(message: value.error.error).show(context);
                                                }
                                              });
                                             }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text(
                                              S.of(context).update,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

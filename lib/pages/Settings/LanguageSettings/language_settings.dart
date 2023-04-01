import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/SettingsBloc/settigns_bloc.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_event.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Setttings/settings_data.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';
import 'package:safaqtek/models/User/user_data.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';

class LanguageSettings extends StatefulWidget {
  final Function(bool) onLoading;
  const LanguageSettings({
    Key? key, required this.onLoading,
  }) : super(key: key);

  @override
  _LanguageSettingsState createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  late MainProvider mainProvider;

  @override
  void initState() {
    super.initState();
  }

  String getCurrentLanguageName(String languageCode) {
    if (languageCode == 'en') {
      return 'ENGLISH';
    } else {
      return 'العربية';
    }
  }
  late final SettingsBloc _settingsBloc = BlocProvider.of<SettingsBloc>(context);

  final SettingsServices _settingsServices = SettingsServices();

  final AuthenticationServices _authenticationServices = AuthenticationServices();
  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context, listen: true);
    return BlocListener(
      listener: (context, state) {
        widget.onLoading(false);
        if (state is UpdateUserLanguageSucceeded) {
          AppFlushBar.showFlushbar(message: state.baseSuccessResponse.message).show(context);
        }
        if (state is UpdateUserLanguageFailed) {
          AppFlushBar.showFlushbar(message: state.baseErrorResponse.error).show(context);
        }
      },
      bloc: _settingsBloc,
      listenWhen: (prev, cur) {
        return prev != cur;
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.whiteLilac,
        ),
        child: DropdownButton<String>(
          items: S.delegate.supportedLocales
              .map(
                (e) => DropdownMenuItem(
                  child: Row(
                    children: [
                      Image.asset(
                        e.languageCode == 'en' ? 'assets/countriesFlags/us.png' : 'assets/countriesFlags/ae.png',
                        width: 30,
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,),
                        child: Text(
                          getCurrentLanguageName(e.languageCode),
                          style: AppStyles.h2.copyWith(fontFamily: locator<MainApp>().language!.languageCode == 'en' ? 'PoppinsSemiBold' : 'CairoSemiBold'),
                        ),
                      ),
                    ],
                  ),
                  value: e.languageCode,
                ),
              )
              .toList(),
          onChanged: (newValue) {
            widget.onLoading(true);
            mainProvider.changeLanguage(Locale(newValue!));
            locator<MainApp>().language = Locale(newValue);
            mainProvider.refresh(value: true);
            _settingsBloc.add(UpdateUserLanguage(
              updateUserProfile: UpdateUserProfile(
                firstName: null,
                email: null,
                addresse: null,
                nationalId: null,
                residenceId: null,
                phone: null,
                sex: null,
                lang: newValue
              ),
            ));
            _authenticationServices.getUserProfile(token: locator<MainApp>().token!).then((userData) {
              if (userData is SuccessState<UserData>){
                locator<MainApp>().currentUser = userData.data.user;
              }
              else if (userData is ErrorState<UserData>){
                AppFlushBar.showFlushbar(message: userData.error.error).show(context);
              }
            });
            _settingsServices.getSettings().then((newSettingsDate) {
              if (newSettingsDate is SuccessState<SettingsData>){
                locator<MainApp>().appSettings = newSettingsDate.data;
              }
              else if (newSettingsDate is ErrorState<SettingsData>){
                AppFlushBar.showFlushbar(message: newSettingsDate.error.error).show(context);
              }
            });
          },
          isExpanded: true,
            style: AppStyles.h2.copyWith(fontFamily: locator<MainApp>().language!.languageCode == 'en' ? 'PoppinsSemiBold' : 'CairoSemiBold'),
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              S.of(context).language,
                style: AppStyles.h2.copyWith(fontFamily: locator<MainApp>().language!.languageCode == 'en' ? 'PoppinsSemiBold' : 'CairoSemiBold')
            ),
          ),
          underline: Container(),
          iconEnabledColor: AppColors.gunPowder,
          iconDisabledColor: AppColors.gunPowder,
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  getCurrentLanguageName(
                      locator<MainApp>().language?.languageCode ?? Localizations.localeOf(context).languageCode),
                  style: AppStyles.h2,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.gunPowder,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

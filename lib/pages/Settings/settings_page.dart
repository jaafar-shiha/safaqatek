import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/SettingsBloc/settigns_bloc.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_event.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/currencies_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';
import 'package:safaqtek/pages/Settings/CurrenciesSettings/currency_card.dart';
import 'package:safaqtek/pages/Settings/CurrenciesSettings/currency_settings.dart';
import 'package:safaqtek/pages/Settings/LanguageSettings/language_settings.dart';
import 'package:safaqtek/pages/Settings/NotificationsSettings/notifications_seetings.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ValueNotifier<bool> showCurrenciesList = ValueNotifier(false);

  ValueNotifier<Currencies> selectedCurrency = ValueNotifier(Currencies.aed);
  bool isLoading = false;
  late MainProvider mainProvider;

  late final SettingsBloc _settingsBloc = BlocProvider.of<SettingsBloc>(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context,listen: false);
    return BlocListener(
      listener: (context, state) {
        setState(() {
          isLoading = false;
        });
        if (state is UpdateUserProfileSucceeded) {
          locator<MainApp>().currentUser!.currency = selectedCurrency.value.name;
          mainProvider.refresh(value: true);
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
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: MainScaffold(
          body: SafeArea(
            child: SingleChildScrollView(
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
                          S.of(context).settings,
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
                    child: ValueListenableBuilder(
                      valueListenable: selectedCurrency,
                      builder: (context, val, child) {
                        return CurrencySettings(
                          currentCurrency: locator<MainApp>().currentUser?.currency?.toUpperCase()??selectedCurrency.value.getCurrencyCode(),
                          onTap: () {
                            showCurrenciesList.value = !showCurrenciesList.value;
                          },
                        );
                      },
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LanguageSettings(
                      onLoading: (value){
                        setState(() {
                          isLoading = value;
                        });
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: NotificationsSettings(),
                  ),
                  ValueListenableBuilder(
                      valueListenable: showCurrenciesList,
                      builder: (context, val, child) {
                        if (showCurrenciesList.value) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.whiteLilac,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ValueListenableBuilder(
                                  valueListenable: selectedCurrency,
                                  builder: (context, val, child) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                S.of(context).chooseCurrency,
                                                style: AppStyles.h2,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  showCurrenciesList.value = false;
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  _settingsBloc.add(
                                                    UpdateProfile(
                                                      updateUserProfile: UpdateUserProfile(
                                                        currency: selectedCurrency.value.name,
                                                        residenceId: null,
                                                        nationalId: null,
                                                        sex: null,
                                                        addresse: null,
                                                        email: null,
                                                        firstName: null,
                                                        lang: null,
                                                        avatar: null
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  S.of(context).done,
                                                  style: AppStyles.h2.copyWith(color: AppColors.dirtyPurple),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ...Currencies.values.map(
                                              (currency) => CurrencyCard(
                                            code: currency.getCurrencyCode(),
                                            flagImagePath: currency.getCurrencyFlag(),
                                            isSelected: selectedCurrency.value == currency,
                                            onTap: () {
                                              selectedCurrency.value = currency;
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

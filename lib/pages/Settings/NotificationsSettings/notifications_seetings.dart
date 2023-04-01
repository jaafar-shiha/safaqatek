import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/SettingsBloc/settigns_bloc.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_event.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';
import 'package:safaqtek/widgets/toggle.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({Key? key}) : super(key: key);

  @override
  _NotificationsSettingsState createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  ValueNotifier<bool> isActivated =
      ValueNotifier(locator<MainApp>().currentUser!.allowNotifications??false);
  late final SettingsBloc _settingsBloc = BlocProvider.of<SettingsBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {},
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).notifications,
                style: AppStyles.h2,
              ),
              ValueListenableBuilder(
                valueListenable: isActivated,
                builder: (context, value, child) {
                  return Toggle(
                    onChanged: (value) {
                      isActivated.value = value;
                      locator<MainApp>().currentUser!.allowNotifications = value;
                      _settingsBloc.add(
                        UpdateProfile(
                          updateUserProfile: UpdateUserProfile(
                            currency: null,
                            residenceId: null,
                            nationalId: null,
                            sex: null,
                            addresse: null,
                            email: null,
                            firstName: null,
                            lang: null,
                            avatar: null,
                            allowNotifications: value,
                          ),
                        ),
                      );
                    },
                    isActivated: isActivated.value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

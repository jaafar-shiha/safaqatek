import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/blocs/SettingsBloc/settigns_bloc.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_event.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Notifications/notifications.dart';
import 'package:safaqtek/pages/Notifications/empty_notifiactions_widget.dart';
import 'package:safaqtek/pages/Notifications/notifications_list.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final SettingsBloc _settingsBloc = BlocProvider.of<SettingsBloc>(context);

  bool isGettingNotifications = true;
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    _settingsBloc.add(const GetNotifications());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context);
    return WillPopScope(
      onWillPop: (){
        tabsProvider.setCurrentTab(currentTab: Tabs.home);
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is GetNotificationsSucceeded) {
            setState(() {
              notifications = state.notificationData.notifications;
              isGettingNotifications = false;
            });
          } else if (state is GetNotificationsFailed) {
            setState(() {
              isGettingNotifications = false;
            });
            AppFlushBar.showFlushbar(message: state.baseErrorResponse.error).show(context);
          }
        },
        bloc: _settingsBloc,
        listenWhen: (prev, cur) {
          return prev != cur;
        },
        child: MainScaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          tabsProvider.setCurrentTab(currentTab: Tabs.home);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.whiteLilac,
                        ),
                      ),
                      Text(
                        S.of(context).notifications,
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
                isGettingNotifications
                    ? Expanded(
                      child: SpinKitPulse(
                          color: AppColors.whiteLilac,
                          duration: const Duration(seconds: 2),
                        ),
                    )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: notifications.isEmpty
                              ? const EmptyNotificationsWidget()
                              : NotificationsList(notifications: notifications),
                        ),
                      ),
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

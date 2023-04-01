import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_event.dart';
import 'package:safaqtek/blocs/SettingsBloc/settings_state.dart';
import 'package:safaqtek/models/Notifications/add_notification.dart';
import 'package:safaqtek/models/Notifications/notifications_data.dart';
import 'package:safaqtek/models/base_success_response.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:safaqtek/utils/result_classes.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  late final SettingsServices _settingsServices = SettingsServices();

  SettingsBloc() : super(const EmptyUpdateProfileState()) {
    on<UpdateProfile>(
          (event, emit) async {
        await _settingsServices.updateUserProfile(updateUserProfile: event.updateUserProfile).then((value) {
          if (value is SuccessState<BaseSuccessResponse>) {
            emit(UpdateUserProfileSucceeded(baseSuccessResponse: value.data));
          } else if (value is ErrorState<BaseSuccessResponse>) {
            emit(UpdateUserProfileFailed(baseErrorResponse: value.error));
          }
        });
      },
    );

    on<AddNotificationEvent>(
          (event, emit) async {
        await _settingsServices.addNotification(addNotification: event.addNotification).then((value) {
          if (value is SuccessState<AddNotification>) {
            emit(const AddNotificationSucceeded());
          } else if (value is ErrorState<AddNotification>) {
            emit(AddNotificationFailed(baseErrorResponse: value.error));
          }
        });
      },
    );


    on<GetNotifications>(
          (event, emit) async {
        await _settingsServices.getNotifications().then((value) {
          if (value is SuccessState<NotificationData>) {
            emit(GetNotificationsSucceeded(notificationData: value.data));
          } else if (value is ErrorState<NotificationData>) {
            emit(GetNotificationsFailed(baseErrorResponse: value.error));
          }
        });
      },
    );

    on<UpdateUserLanguage>(
          (event, emit) async {
        await _settingsServices.updateUserProfile(updateUserProfile: event.updateUserProfile).then((value) {
          if (value is SuccessState<BaseSuccessResponse>) {
            emit(UpdateUserLanguageSucceeded(baseSuccessResponse: value.data));
          } else if (value is ErrorState<BaseSuccessResponse>) {
            emit(UpdateUserLanguageFailed(baseErrorResponse: value.error));
          }
        });
      },
    );
  }
}
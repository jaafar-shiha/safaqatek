import 'package:safaqtek/models/Notifications/notifications_data.dart';
import 'package:safaqtek/models/base_error_response.dart';
import 'package:safaqtek/models/base_success_response.dart';

abstract class SettingsState{
  const SettingsState();
}

class EmptyUpdateProfileState extends SettingsState{
  const EmptyUpdateProfileState();
}

class UpdateUserProfileSucceeded extends SettingsState{
  final BaseSuccessResponse baseSuccessResponse;
  const UpdateUserProfileSucceeded({required this.baseSuccessResponse});
}

class UpdateUserProfileFailed extends SettingsState{
  final BaseErrorResponse baseErrorResponse;
  const UpdateUserProfileFailed({required this.baseErrorResponse});
}

class AddNotificationSucceeded extends SettingsState{
  const AddNotificationSucceeded();
}

class AddNotificationFailed extends SettingsState{
  final BaseErrorResponse baseErrorResponse;
  const AddNotificationFailed({required this.baseErrorResponse});
}


class GetNotificationsSucceeded extends SettingsState{
  final NotificationData notificationData;
  const GetNotificationsSucceeded({required this.notificationData});
}

class GetNotificationsFailed extends SettingsState{
  final BaseErrorResponse baseErrorResponse;
  const GetNotificationsFailed({required this.baseErrorResponse});
}


class UpdateUserLanguageSucceeded extends SettingsState{
  final BaseSuccessResponse baseSuccessResponse;
  const UpdateUserLanguageSucceeded({required this.baseSuccessResponse});
}

class UpdateUserLanguageFailed extends SettingsState{
  final BaseErrorResponse baseErrorResponse;
  const UpdateUserLanguageFailed({required this.baseErrorResponse});
}
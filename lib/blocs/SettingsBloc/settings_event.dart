import 'package:equatable/equatable.dart';
import 'package:safaqtek/models/Notifications/add_notification.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class UpdateProfile extends SettingsEvent{
  final UpdateUserProfile updateUserProfile;
  const UpdateProfile({required this.updateUserProfile});

  @override
  List<Object?> get props => [];
}


class AddNotificationEvent extends SettingsEvent{
  final AddNotification addNotification;
  const AddNotificationEvent({required this.addNotification});

  @override
  List<Object?> get props => [];
}

class GetNotifications extends SettingsEvent{
  const GetNotifications();

  @override
  List<Object?> get props => [];
}


class UpdateUserLanguage extends SettingsEvent{
  final UpdateUserProfile updateUserProfile;
  const UpdateUserLanguage({required this.updateUserProfile});

  @override
  List<Object?> get props => [];
}
import 'package:safaqtek/models/Notifications/notifications.dart';

class NotificationData {
  NotificationData({
    required this.notifications,
  });

  List<NotificationModel> notifications;

  NotificationData copyWith({
    List<NotificationModel>? notifications,
  }) =>
      NotificationData(
        notifications: notifications ?? this.notifications,
      );

  factory NotificationData.fromMap(Map<String, dynamic> json) => NotificationData(
    notifications: List<NotificationModel>.from(json["data"].map((x) => NotificationModel.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(notifications.map((x) => x.toMap())),
  };
}

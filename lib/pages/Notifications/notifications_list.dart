import 'package:flutter/material.dart';
import 'package:safaqtek/models/Notifications/notifications.dart';
import 'package:safaqtek/pages/Notifications/notifiaction_card.dart';

class NotificationsList extends StatefulWidget {
  final List<NotificationModel> notifications;

  const NotificationsList({Key? key, required this.notifications}) : super(key: key);

  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: widget.notifications
            .map(
              (notification) => NotificationCard(title: notification.title, date: notification.createdAt),
            )
            .toList(),
      ),
    );
  }
}

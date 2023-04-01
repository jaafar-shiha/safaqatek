import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Notifications/add_notification.dart';
import 'package:safaqtek/models/User/user.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMServices {
  static final onNotification = BehaviorSubject<String?>();
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
  );

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final SettingsServices _settingsServices = SettingsServices();

  FCMServices() {
    initFCMServices();
  }

  Future<void> initFCMServices() async {
    const android = AndroidInitializationSettings('logo');
    const ios = IOSInitializationSettings();
    const settings = InitializationSettings(iOS: ios, android: android);
    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onSelectNotification: (payload) {
        onNotification.add(payload);
      },
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings2 = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    print('spon');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('spon1');
      String? targetEmail = message.data['email'];
      User? user;
      if (locator<MainApp>().currentUser?.allowNotifications ?? true) {
        if (preferences.getString('user') != null) {
          user = User.fromMap(jsonDecode(preferences.getString('user')!));
        }
        print('spon2');
        if (targetEmail != null) {
          if (user?.email == targetEmail) {
            if (notification != null && android != null) {
              _flutterLocalNotificationsPlugin.show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      _channel.id,
                      _channel.name,
                      channelDescription: _channel.description,
                      color: Colors.blue,
                      playSound: true,
                      icon: '@mipmap/launcher_icon',
                    ),
                  ));
              _settingsServices.addNotification(
                  addNotification: AddNotification(title: notification.title ?? '', body: notification.body ?? ''));
            }
          }
        } else {
          if (notification != null && android != null) {
            _flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    _channel.id,
                    _channel.name,
                    channelDescription: _channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/launcher_icon',
                  ),
                ));
            _settingsServices.addNotification(
                addNotification: AddNotification(title: notification.title ?? '', body: notification.body ?? ''));
          }
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      String? targetEmail = message.data['email'];
      User? user;
      if (locator<MainApp>().currentUser?.allowNotifications ?? true) {
        if (preferences.getString('user') != null) {
          user = User.fromMap(jsonDecode(preferences.getString('user')!));
        }
        if (targetEmail != null) {
          if (user?.email == targetEmail) {
            if (notification != null && android != null) {
              _flutterLocalNotificationsPlugin.show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      _channel.id,
                      _channel.name,
                      channelDescription: _channel.description,
                      color: Colors.blue,
                      playSound: true,
                      icon: '@mipmap/launcher_icon',
                    ),
                  ));
              _settingsServices.addNotification(
                  addNotification: AddNotification(title: notification.title ?? '', body: notification.body ?? ''));
            }
          }
        } else {
          if (notification != null && android != null) {
            _flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    _channel.id,
                    _channel.name,
                    channelDescription: _channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/launcher_icon',
                  ),
                ));
            _settingsServices.addNotification(
                addNotification: AddNotification(title: notification.title ?? '', body: notification.body ?? ''));
          }
        }
      }
    });
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('high_importance_channel', 'high_importance_channel',
            channelDescription: 'This channel is used for important notifications.', //
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(),
    );
    await _flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'item x');
  }
}

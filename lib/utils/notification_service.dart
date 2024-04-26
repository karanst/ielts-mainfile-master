import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

AndroidInitializationSettings initializationSettingsAndroid =
const AndroidInitializationSettings('ic_launcher');
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
late DarwinInitializationSettings initializationSettingsIOS;
late InitializationSettings initializationSettings;

class NotificationService {
  static Future<void> init() async {
    initializationSettingsIOS = const DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
      onDidReceiveBackgroundNotificationResponse: selectNotificationBackground,
    );
  }

  static Future<void> firebaseMessaging() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('onMessage listener');
      if (message.data['priority'] == 'high') {
        await display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('onMessageOpenedApp listener');

      if (message.data["id"] != null) {
        selectNotification(NotificationResponse(
          notificationResponseType:
          NotificationResponseType.selectedNotification,
          payload: jsonEncode(message.data),
          id: int.parse(message.data["id"] ?? '0'),
        ));
      }
    });

    // FirebaseMessaging.instance.getInitialMessage(){};

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> stopNotification() async {
    await FirebaseMessaging.instance.deleteToken();
    await FirebaseMessaging.instance.setAutoInitEnabled(false);
  }

  static void onDidReceiveLocalNotification(
      int id,
      String? title,
      String? body,
      String? payload,
      ) async {
    // Handle local notifications
  }
}

Future<void> selectNotification(NotificationResponse details) async {
  log('notificationSelecter ${details.notificationResponseType}');

  if (details.payload == null) return;
  Map<String, dynamic> payload = jsonDecode(details.payload ?? '{}');

  // Handle notification selection logic here
}

Future<void> selectNotificationBackground(NotificationResponse details) async {
  log('background notificationSelecter');
  if (details.payload == null) return;

  Map<String, dynamic> payload = jsonDecode(details.payload ?? '{}');

  // Handle background notification selection logic here
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('onBackgroundMessage listener');
}

Future<void> generateSimpleNotication(
    String title, String msg, String type, String id) async {
  AndroidNotificationDetails androidNotificationDetails =
  const AndroidNotificationDetails(
    'channelId',
    'channelName',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
  );
  // var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //   'channel_id',
  //   'your channel name',
  //   channelDescription: 'your channel description',
  //   importance: Importance.max,
  //   priority: Priority.high,
  //   playSound: true,
  // );
  var iosDetail = const DarwinNotificationDetails();

  var platformChannelSpecifics =
  NotificationDetails(android: androidNotificationDetails, iOS: iosDetail);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    msg,
    platformChannelSpecifics,
    payload: '$type,$id',
  );
}

Future<void> display(RemoteMessage message) async {}

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}
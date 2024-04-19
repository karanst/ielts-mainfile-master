// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'package:http/http.dart' as http;
//
//
// AndroidInitializationSettings initializationSettingsAndroid =
// const AndroidInitializationSettings('ic_launcher');
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
// late DarwinInitializationSettings initializationSettingsIOS;
// late InitializationSettings initializationSettings;
//
// class NotificationService {
//   static Future<void> init() async {
//     initializationSettingsIOS = const DarwinInitializationSettings(
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );
//     initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: selectNotification,
//       onDidReceiveBackgroundNotificationResponse: selectNotificationBackground,
//     );
//   }
//
//   // static Future<void> firebaseMessaging() async {
//   //   await Firebase.initializeApp();
//   //   await FirebaseMessaging.instance.requestPermission(
//   //     alert: true,
//   //     badge: true,
//   //     sound: true,
//   //   );
//   //   await FirebaseMessaging.instance
//   //       .setForegroundNotificationPresentationOptions(
//   //     alert: true,
//   //     badge: true,
//   //     sound: true,
//   //   );
//   //
//   //   // if (UserInfo().token == null) {
//   //   //   await FirebaseMessaging.instance.setAutoInitEnabled(false);
//   //   // } else {
//   //     await FirebaseMessaging.instance.setAutoInitEnabled(true);
//   //     final String? token = await FirebaseMessaging.instance.getToken();
//   //     log('token $token');
//   //   // }
//   //
//   //   FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
//   //     log('onMessage listener');
//   //     if (message != null) {
//   //       if (message.data['priority'] == 'high') {
//   //         await display(message);
//   //       }
//   //     }
//   //   });
//   //
//   //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
//   //     log('onMessageOpenedApp listener');
//   //
//   //     if (message != null) {
//   //       if (message.data["id"] != null) {
//   //         selectNotification(NotificationResponse(
//   //           notificationResponseType:
//   //           NotificationResponseType.selectedNotification,
//   //           payload: jsonEncode(message.data),
//   //           id: int.parse(message.data["id"] ?? 0),
//   //         ));
//   //       } else {}
//   //     }
//   //   });
//   //
//   //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   // }
//
//   static Future<void> stopNotification() async {
//     await FirebaseMessaging.instance.deleteToken();
//     await FirebaseMessaging.instance.setAutoInitEnabled(false);
//   }
//
//   static void onDidReceiveLocalNotification(
//       int id,
//       String? title,
//       String? body,
//       String? payload,
//       ) async {
//     // showDialog(
//     //   context: NavigationService.context,
//     //   builder: (BuildContext context) => CupertinoAlertDialog(
//     //     title: Text(title ?? ''),
//     //     content: Text(body ?? ''),
//     //     actions: [
//     //       CupertinoDialogAction(
//     //         isDefaultAction: true,
//     //         child: const Text('Ok'),
//     //         onPressed: () async {
//     //           Navigator.of(context, rootNavigator: true).pop();
//     //         },
//     //       )
//     //     ],
//     //   ),
//     // );
//   }
// }
//
// Future<void> selectNotification(NotificationResponse details) async {
//   log('notificationSelecter ${details.notificationResponseType}');
//
//   if (details.payload == null) return;
//   Map<String, dynamic> payload = jsonDecode(details.payload ?? '{}');
//
//   if (details.notificationResponseType !=
//       NotificationResponseType.selectedNotification) {
//     // if ((payload['topic']).toLowerCase() == 'survey') {
//     //
//     // } else {}
//   }
// }
//
// Future<void> selectNotificationBackground(NotificationResponse details) async {
//   log('background notificationSelecter');
//   if (details.payload == null) return;
//
//   Map<String, dynamic> payload = jsonDecode(details.payload ?? '{}');
//
//   // if (payload['topic'].toLowerCase() == 'survey') {
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     showSurvey(int.tryParse(payload['id']));
//   //   });
//   // }
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log('onBackgroundMessage listener');
// }
//
// Future<void> generateSimpleNotication(
//     String title, String msg, String type, String id) async {
//   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//     'your channel id',
//     'your channel name',
//     channelDescription: 'your channel description',
//     importance: Importance.max,
//     priority: Priority.high,
//     playSound: true,
//   );
//   var iosDetail = const DarwinNotificationDetails();
//
//   var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: iosDetail);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     msg,
//     platformChannelSpecifics,
//     payload: '$type,$id',
//   );
// }
//
//
//
// // Future<void> display(RemoteMessage message) async {
// //   final ByteArrayAndroidBitmap? bigPicture = message
// //       .notification!.android!.imageUrl !=
// //       null
// //       ? ByteArrayAndroidBitmap(
// //     await _getByteArrayFromUrl(message.notification!.android!.imageUrl!),
// //   )
// //       : null;
// //
// //   final BigPictureStyleInformation? bigPictureStyleInformation =
// //   message.notification?.android?.imageUrl != null
// //       ? BigPictureStyleInformation(
// //     bigPicture!,
// //     largeIcon: bigPicture,
// //   )
// //       : null;
// //
// //   // AndroidNotificationDetails androidPlatformChannelSpecifics =
// //   // AndroidNotificationDetails(
// //   //   'my_app',
// //   //   'my_app channel',
// //   //   channelDescription: 'This is our channel',
// //   //   styleInformation: bigPictureStyleInformation,
// //   //   importance: Importance.max,
// //   //   priority: Priority.high,
// //   //   ticker: 'ticker',
// //   //   playSound: true,
// //   //   sound: const RawResourceAndroidNotificationSound('slow_spring_board'),
// //   //   icon: '@drawable/notification_icon',
// //   //   color: const Color(0xFFFFC23D1),
// //   //   largeIcon: bigPicture,
// //   // );
// //
// //   DarwinNotificationDetails iosNotificationDetails =
// //   const DarwinNotificationDetails(
// //     presentAlert: true,
// //     presentBadge: true,
// //     presentSound: true,
// //   );
// //   NotificationDetails platformChannelSpecifics = NotificationDetails(
// //     android: androidPlatformChannelSpecifics,
// //     iOS: iosNotificationDetails,
// //   );
// //   showNotification(
// //     platformChannelSpecifics,
// //     message,
// //   );
// // }
//
// showNotification(
//     NotificationDetails platformChannelSpecifics,
//     RemoteMessage message,
//     ) async {
//   final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//
//   // if (NavigationService.currentRouteName == VocabularyActivity.routeName &&
//   //     message.data['topic'].toLowerCase() == 'survey') {
//   //   UserInfo userInfo = UserInfo();
//   //   if (message.data['id'] != null) {
//   //     userInfo.setSurveyId(int.parse(message.data['id']));
//   //   }
//   // } else {
//   //   if (NavigationService.currentRouteName != null) {
//       selectNotification(
//         NotificationResponse(
//           notificationResponseType:
//           NotificationResponseType.selectedNotificationAction,
//           payload: jsonEncode(message.data),
//         ),
//       );
//     // }
//     if (message.data["id"] != null) {
//       await flutterLocalNotificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         platformChannelSpecifics,
//         payload: jsonEncode(message.data),
//       );
//     } else {
//       await flutterLocalNotificationsPlugin.show(
//         id,
//         message.notification!.title,
//         message.notification!.body,
//         platformChannelSpecifics,
//       );
//     }
//   // }
// }
//
// Future<Uint8List> _getByteArrayFromUrl(String url) async {
//   final http.Response response = await http.get(Uri.parse(url));
//   return response.bodyBytes;
// }

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

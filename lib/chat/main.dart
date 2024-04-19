// import 'package:chatapp/screens/auth/login_screen.dart';
// // import 'package:chatapp/screens/home_screen.dart';
// // import 'package:chatapp/screens/splach_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_notification_channel/flutter_notification_channel.dart';
// import 'package:flutter_notification_channel/notification_importance.dart';
// import 'package:flutter_notification_channel/notification_visibility.dart';

// import 'firebase_options.dart';

// late Size mq;
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   _initializeFirebase();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'IELTS - YAN',
//         theme: ThemeData(
//           primarySwatch: Colors.teal,
//         ),
//         home: SplashScreen());
//   }
// }

// _initializeFirebase() async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   var result = await FlutterNotificationChannel.registerNotificationChannel(
//       description: 'For Showing Message Notification',
//       id: 'ieltsyan',
//       importance: NotificationImportance.IMPORTANCE_HIGH,
//       name: 'ieltsyan');
//   print('\nNotification Channel Result: $result');
// }

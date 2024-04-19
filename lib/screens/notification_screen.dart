import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ielts/screens/message_handler_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final message =
    //     ModalRoute.of(context)!.settings.arguments as RemoteMessage?;

    // if (message == null || message.notification == null) {
    //   // Handle the case where message or notification is null
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Notifications'),
    //     ),
    //     body: Center(
    //       child: Column(
    //         children: [
    //           Text('${message?.notification!.body}'),
    //           Text('${message?.notification!.title}'),
    //           Text('${message?.data}'),
    //         ],
    //       ),
    //     ),
    //   );
    // }
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message.notification!.title.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                message.notification!.body.toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Text(
                message.data.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

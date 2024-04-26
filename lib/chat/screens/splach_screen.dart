import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ielts/chat/api/apis.dart';
import 'package:ielts/chat/screens/auth/login_screen.dart';
import 'package:ielts/chat/screens/chat_screen.dart';
import 'package:ielts/main.dart';

import '../../screens/login_screen.dart';
import '../main.dart';
import 'chat_main_screen.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white, statusBarColor: Colors.white);
      if (APIs.auth.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ChatMainScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen1(title: 'Login',)));
      }
    });
  }

  Future<void> setupInteractedMessage() async {
    print('initialize');
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print('handling');
    if (message.data['type'] == 'chat') {
      // Navigator.pushNamed(context, '/chat',
      //   arguments: ChatScreen(user: message,),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //appbar

      //appbar
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * .10,
            right: MediaQuery.of(context).size.width * .25,
            width: MediaQuery.of(context).size.width * .5,
            child: Image.asset('assets/icon.png'),
          ),
          Positioned(
              bottom: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'Make for you with love',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )))
        ],
      ),
    );
  }
}

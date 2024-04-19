import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ielts/utils/app_constants.dart';
import 'package:ielts/services/auth.dart';

class SplashScreen extends StatefulWidget {
  // SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      checkUserAndNavigate();
    });
  }

  void checkUserAndNavigate() {
    if (currentUser == null) {
      Navigator.pushReplacementNamed(
        context,
        RoutePaths.login,
      );
    } else {
      userId = currentUser?.uid ?? '';
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser?.uid)
          .get()
          .then((DocumentSnapshot result) =>
              Navigator.popAndPushNamed(context, RoutePaths.home))
          .catchError((err) => print(err));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: Image.asset('assets/giphy.gif'),
        ),
      ),
    );
  }
}

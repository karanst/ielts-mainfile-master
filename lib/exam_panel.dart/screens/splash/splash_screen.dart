import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_colors.dart';
import 'package:ielts/utils/app_constants.dart';

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({Key? key});

  @override
  Widget build(BuildContext context) {
    // Delayed navigation function
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushNamed(
          RoutePaths.introduction); // Navigate to the specified route
    });

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Image.asset(
          'assets/images/app_splash_logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

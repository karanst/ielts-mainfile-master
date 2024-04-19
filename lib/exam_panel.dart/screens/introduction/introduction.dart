import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_colors.dart';
import 'package:ielts/exam_panel.dart/controllers/question_page/question_paper_controller.dart';
import 'package:ielts/exam_panel.dart/firebase_ref/firebase_storage_service.dart';
import 'package:ielts/exam_panel.dart/screens/app_circuler_botton.dart';
import 'package:ielts/exam_panel.dart/screens/home/home_screen.dart';
import 'package:ielts/utils/app_constants.dart';

class AppIntroductionScreen extends StatelessWidget {
  const AppIntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: mainGradient(context)),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * .1),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.star,
              size: 65,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "This is for student who want to give exam test for ielts that will be for premioum user",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: onSurfaceTextColor,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            AppCirculerBotton(
              onTap: () {
                Get.put(FirebaseStorageService());
                Get.put(
                    QuestionPaperController()); // Initialize controller here
                Get.toNamed(RoutePaths.examHome);
              },
              child: Icon(Icons.arrow_forward, size: 35),
            ),
          ]),
        ),
      ),
    );
  }
}

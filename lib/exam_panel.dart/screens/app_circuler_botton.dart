import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ielts/exam_panel.dart/controllers/question_page/question_paper_controller.dart';
import 'package:ielts/exam_panel.dart/firebase_ref/firebase_storage_service.dart';
import 'package:ielts/exam_panel.dart/screens/home/home_screen.dart';
import 'package:ielts/utils/app_constants.dart';

class AppCirculerBotton extends StatelessWidget {
  const AppCirculerBotton({
    super.key,
    required this.child,
    this.color,
    this.width = 60,
    this.onTap,
  });
  final Widget child;
  final Color? color;
  final double width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      shape: CircleBorder(),
      child: InkWell(
        onTap: () {
          Get.put(FirebaseStorageService());
          Get.put(QuestionPaperController()); // Initialize controller here
          Get.toNamed(RoutePaths.examHome);
        },
        child: child,
      ),
    );
  }
}

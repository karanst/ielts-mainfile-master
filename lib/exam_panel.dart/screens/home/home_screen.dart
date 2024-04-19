import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ielts/exam_panel.dart/controllers/question_page/question_paper_controller.dart';

class ExamHomeScreen extends StatelessWidget {
  const ExamHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    QuestionPaperController _questionPaperController = Get.find();
    return Scaffold(
      body: Obx(
        () => ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              child: SizedBox(
                height: 200,
                width: 200,
                child: FadeInImage(
                  image: NetworkImage(
                    _questionPaperController.allPaperImages[index],
                  ),
                  placeholder: AssetImage("assets/images/app_splash_logo.png"),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 20,
            );
          },
          itemCount: _questionPaperController.allPaperImages.length,
        ),
      ),
    );
  }
}

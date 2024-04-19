import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ielts/exam_panel.dart/controllers/question_page/data_uploader.dart';
import 'package:ielts/exam_panel.dart/firebase_ref/loading_status.dart';

class DataUploaderScreen extends StatelessWidget {
  DataUploaderScreen({super.key});
  DataUploader controller = Get.put(DataUploader());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Text(controller.loadingStatus.value == LoadingStatus.completed
              ? "Uploading complated "
              : "Uploading..."),
        ),
      ),
    );
  }
}

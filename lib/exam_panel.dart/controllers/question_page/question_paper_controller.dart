import 'dart:developer';

import 'package:get/get.dart';
import 'package:ielts/exam_panel.dart/firebase_ref/firebase_storage_service.dart';

class QuestionPaperController extends GetxController {
  final allPaperImages = <String>[].obs;
  @override
  void onReady() {
    getAllPapers();

    super.onReady();
  }

  Future<void> getAllPapers() async {
    List<String> imgName = [
      "biology",
      "chemistry",
      "math",
      "physics",
    ];
    try {
      for (var img in imgName) {
        final imgUrl = await Get.find<FirebaseStorageService>().getImage(img);
        allPaperImages.add(imgUrl!);
      }
    } catch (e) {
      log('Error in getting all papers $e');
    }
  }
}

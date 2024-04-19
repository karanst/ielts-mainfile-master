import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ielts/exam_panel.dart/firebase_ref/loading_status.dart';
import 'package:ielts/exam_panel.dart/firebase_ref/reference.dart';
import 'package:ielts/exam_panel.dart/models/question_paper_model.dart';
import 'package:ielts/models/quiz.dart';

class DataUploader extends GetxController {
  void onReady() {
    uploadData();
    super.onReady();
  }

  final loadingStatus = LoadingStatus.loading.obs; //loading status is obs

  Future<void> uploadData() async {
    loadingStatus.value = LoadingStatus.loading; //0

    // log('Data is Uploading');
    final firebase = FirebaseFirestore.instance;
    final manifestContent = await DefaultAssetBundle.of(Get.context!)
        .loadString("AssetManifest.json");
    // Load json file and print path

    final Map<String, dynamic> manifestMap = json
        .decode(manifestContent); // Use json.decode() instead of json.encode()

    final papersInAssets = manifestMap.keys
        .where((path) =>
            path.startsWith("assets/DB/paper") && path.contains(".json"))
        .toList();
    print(papersInAssets);
    List<QuestionPaperModel> questionPapers = [];
    for (var paper in papersInAssets) {
      String stringPaperContent = await rootBundle.loadString(paper);
      log(stringPaperContent);
      questionPapers
          .add(QuestionPaperModel.fromJson(jsonDecode(stringPaperContent)));
    }
    // log('Item number ${questionPapers[0].id}');

    var batch = firebase.batch();

    for (var paper in questionPapers) {
      batch.set(questionPaperRF.doc(paper.id), {
        "title": paper.title,
        "image_url": paper.imageUrl,
        "description": paper.description,
        "time_second": paper.timeSeconds,
        "questions_count":
            paper.questions == null ? 0 : paper.questions!.length,
      });
      for (var questions in paper.questions!) {
        final questionPath =
            questionRF(paperId: paper.id, questionId: questions.id);
        batch.set(questionPath, {
          "question": questions.question,
          "currect_answer": questions.correctAnswer
        });
        for (var answer in questions.answers) {
          batch.set(questionPath.collection("answers").doc(answer.identifier), {
            "identifier": answer.identifier,
            "answer": answer.answer,
          });
        }
      }
    }

    await batch.commit();
    loadingStatus.value = LoadingStatus.completed; //1
  }
}

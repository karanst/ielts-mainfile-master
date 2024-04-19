import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ielts/locator.dart';
import 'package:ielts/models/lesson.dart';
import 'package:ielts/services/api.dart';

class CrudModel extends ChangeNotifier {
  Api _api = locator<Api>();
  List<Lesson>? lessons;

  Future<List<Lesson>?> fetchLesson() async {
    var result = await _api.getDataCollection();
    lessons = result.docs
        .map((doc) => Lesson.fromMap(doc.data  as Map, doc.id))
        .toList();
    return lessons;
  }

  Stream<QuerySnapshot> fetchLessonsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Lesson> getLessonById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Lesson.fromMap(doc.data as Map, doc.id);
  }

  Future removeProduct(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateProduct(Lesson data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }
}

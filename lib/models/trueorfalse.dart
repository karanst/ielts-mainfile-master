import 'package:flutter/foundation.dart';

class TrueOrFalse extends ChangeNotifier {
  String id;
  String question;
  String title;
  String level;
  List initialQuestions;
  List endingQuestions;
  String paragraph;
  List answers;
  String initialQuestionNumbers;
  String endingQuestionNumbers;
  String whatToDo;
  bool extraData;
  String summary;
  bool isTrue;
  int indicatorValue;
  bool? userSelection; // New property to store user's True/False selection

  TrueOrFalse({
    required this.id,
    required this.question,
    required this.title,
    required this.isTrue,
    required this.initialQuestions,
    required this.endingQuestions,
    required this.paragraph,
    required this.answers,
    required this.initialQuestionNumbers,
    required this.endingQuestionNumbers,
    required this.whatToDo,
    required this.extraData,
    required this.summary,
    required this.indicatorValue,
    required this.level,

  });

  TrueOrFalse.fromMap(Map<dynamic, dynamic> snapshot, String id)
      : id = snapshot['id'] ?? '',
        question = snapshot['question'] ?? '',
        title = snapshot['title'] ?? '',
        initialQuestions = snapshot['initialQuestions'] ?? [],
        endingQuestions = snapshot['endingQuestions'] ?? [],
        paragraph = snapshot['paragraph'] ?? '',
        answers = snapshot['answers'] ?? [],
        initialQuestionNumbers = snapshot['initialQuestionNumbers'] ?? '',
        endingQuestionNumbers = snapshot['endingQuestionNumbers'] ?? '',
        whatToDo = snapshot['whatToDo'] ?? '',
        extraData = snapshot['extraData'] ?? false,
        summary = snapshot['summary'] ?? '',
        isTrue = snapshot['isTrue'] ?? false,
        indicatorValue = snapshot['indicatorValue'] ?? 0,
        level = snapshot['level'] ?? '';

  toJson() {
    return {
      "id": id,
      "question": question,
      "isTrue": isTrue,
      "level": level,
      "title": title,
      "indicatorValue": indicatorValue,
      "initialQuestions": initialQuestions,
      "endingQuestions": endingQuestions,
      "answers": answers,
      "paragraph": paragraph,
      "initialQuestionNumbers": initialQuestionNumbers,
      "endingQuestionNumbers": endingQuestionNumbers,
      "whatToDo": whatToDo,
      "extraData": extraData,
      "summary": summary

    };
  }

  void updateProperties({
    required String newId,
    required String newQuestion,
    required bool newIsTrue,
  }) {
    id = newId;
    question = newQuestion;
    isTrue = newIsTrue;

    notifyListeners();
  }

  void setUserSelection(bool value) {
    userSelection = value;
    notifyListeners();
  }
}

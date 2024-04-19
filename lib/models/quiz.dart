class Quiz {
  List<Question> questions;
  String id;
  double indicatorValue;
  String quizTitle;

  Quiz({
    required this.questions,
    required this.id,
    required this.indicatorValue,
    required this.quizTitle,
  });

  Quiz.fromMap(Map<String, dynamic> snapshot, String id)
      : questions = (snapshot['questions'] as List<dynamic>? ?? [])
      .map((questionData) => Question.fromMap(questionData))
      .toList(),
        id = id,
        indicatorValue = (snapshot['indicatorValue'] ?? 0).toDouble(),
        quizTitle = snapshot['quizTitle'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      "questions": questions.map((question) => question.toJson()).toList(),
      "id": id,
      "indicatorValue": indicatorValue,
      "quizTitle": quizTitle,
    };
  }
}

class Question {
  String questionText;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Question.fromMap(Map<String, dynamic> questionData) {
    return Question(
      questionText: questionData['questionText'] ?? '',
      options: List<String>.from(questionData['options'] ?? []),
      correctOptionIndex: questionData['correctOptionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "questionText": questionText,
      "options": options,
      "correctOptionIndex": correctOptionIndex,
    };
  }
}

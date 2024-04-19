class MCQs {
  final String id;
  // final String question;
  String level;
  String title;
  String initialQuestionNumbers;
  String endingQuestionNumbers;
  List<String> initialQuestions;
  List<String> endingQuestions;
  List<String> answers;
  // final List<String> options;
  // final int correctAnswerIndex;

  MCQs({
    required this.id,
    // required this.question,
    required this.level,
    // required this.options,
    required this.title,
    required this.initialQuestionNumbers,
    required this.endingQuestionNumbers,
    required this.initialQuestions,
    required this.endingQuestions,
    required this.answers,
    // required this.correctAnswerIndex,
  });

  factory MCQs.fromMap(Map<String, dynamic> map, String id) {
    return MCQs(
      id: id,
      // question: map['question'] ?? '',
      title: map['title'] ?? '',
      initialQuestionNumbers: map['initialQuestionNumbers'] ?? '',
      endingQuestionNumbers: map['endingQuestionNumbers'] ?? '',
      initialQuestions: List<String>.from(map['initialQuestions'] ?? []),
      endingQuestions: List<String>.from(map['endingQuestions'] ?? []),
      answers: List<String>.from(map['answers'] ?? []),
      level: map['level'] ?? '',
      // options: List<String>.from(map['options'] ?? []),
      // correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
      'level': level,
      'title': title,
      'initialQuestionNumbers': initialQuestionNumbers,
      'endingQuestionNumbers': endingQuestionNumbers,
      'initialQuestions': initialQuestions,
      'endingQuestions': endingQuestions,
      'answers': answers,
     
    };
  }
}

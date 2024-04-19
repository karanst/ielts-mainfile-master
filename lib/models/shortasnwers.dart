class ShortAnswer {
  String id;
  String title;
  List initialQuestions;
  List endingQuestions;
  String initialQuestionNumbers;
  String endingQuestionNumbers;
  String level;
  List answers;

  ShortAnswer({
    required this.id,
    required this.level,
    required this.initialQuestions,
    required this.endingQuestions,
    required this.initialQuestionNumbers,
    required this.answers,
    required this.endingQuestionNumbers,
    required this.title,

  });

  ShortAnswer.fromMap(Map<String, dynamic> map, String id)
      : id = map['id'] ?? '',
        level = map['level'] ?? '',
        title = map['title'] ?? '',
        answers = List<String>.from(map['answers']),
        initialQuestionNumbers = map['initialQuestionNumbers'] ?? '',
        endingQuestionNumbers = map['endingQuestionNumbers'] ?? '',
        initialQuestions = List<String>.from(map['initialQuestions']),
        endingQuestions = List<String>.from(map['endingQuestions']);


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level' : level,
      'title': title,
      'answers': answers,
      'initialQuestions': initialQuestions,
      'initialQuestionNumbers': initialQuestionNumbers,
      'endingQuestionNumbers': endingQuestionNumbers,
      'endingQuestions': endingQuestions,

    };
  }
}

class MatchEndings {
  String id;
  String level;
  String title;
  String initialQuestionNumbers;
  String endingQuestionNumbers;
  List initialQuestions;
   List endingQuestions;
   List answers;
  MatchEndings({
    required this.id,
    required this.level,
    required this.title,
    required this.initialQuestionNumbers,
     required this.endingQuestionNumbers,
    required this.initialQuestions,
    required this.endingQuestions,
     required this.answers,
  });
  MatchEndings.fromMap(Map<String, dynamic> map, String id)
      : id = map['id'] ?? '',
        level = map['level'] ?? '',
        title = map['title'] ?? '',
        initialQuestionNumbers = map['initialQuestionNumbers'] ?? '',
        endingQuestionNumbers = map['endingQuestionNumbers'] ?? '',
        initialQuestions = List<String>.from(map['initialQuestions']),
        endingQuestions = List<String>.from(map['endingQuestions']),
        answers = List<String>.from(map['answers']);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

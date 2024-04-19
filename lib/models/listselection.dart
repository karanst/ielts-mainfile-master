class ListSelection {
  String id; // Add this line
  String level;
  String title;
  String initialQuestionNumbers;
  String endingQuestionNumbers;
  List initialQuestions;
  List endingQuestions;
  List answers;

  ListSelection({
    required this.id, // Add this line

    required this.level,
    required this.title,


    required this.initialQuestionNumbers,
    required this.endingQuestionNumbers,
    required this.initialQuestions,
    required this.endingQuestions,
    required this.answers,

  });

  ListSelection.fromMap(Map<String, dynamic> map, String id)
      : id = map['id'] ?? '', // Add this line

        level = map['level'] ?? '',
        title = map['title'] ?? '',
        initialQuestionNumbers = map['initialQuestionNumbers'] ?? '',
        endingQuestionNumbers = map['endingQuestionNumbers'] ?? '',
        initialQuestions = List<String>.from(map['initialQuestions']),
        endingQuestions = List<String>.from(map['endingQuestions']),
        answers = List<String>.from(map['answers']);

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Add this line
      'title': title,
      'level': level,
      'initialQuestionNumbers': initialQuestionNumbers,
      'endingQuestionNumbers': endingQuestionNumbers,
      'initialQuestions': initialQuestions,
      'endingQuestions': endingQuestions,
      'answers': answers,
    };
  }
}

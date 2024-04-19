class MatchingParagraphs {
  final String id;
  final String title;
  final String initialQuestionNumbers;
  List initialQuestions;
  final String endingQuestionNumbers;
  List endingQuestions;
  List answers;
  String level;
  MatchingParagraphs({
    required this.id,
    required this.level,
    required this.title,
    required this.initialQuestionNumbers,
    required this.initialQuestions,
    required this.endingQuestionNumbers,
    required this.endingQuestions,
    required this.answers,
  });

  factory MatchingParagraphs.fromMap(Map<String, dynamic> map, String id) {
    return MatchingParagraphs(
      id: id,
      level: map['level'] ?? '',
      title: map['title'] ?? '',
      initialQuestionNumbers: map['initialQuestionNumbers'] ?? '',
      initialQuestions: List<String>.from(map['initialQuestions']),
      endingQuestionNumbers: map['endingQuestionNumbers'] ?? '',
      endingQuestions: List<String>.from(map['endingQuestions']),
      answers: List<String>.from(map['answers']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'title': title,
      'initialQuestionNumbers': initialQuestionNumbers,
      'initialQuestions': initialQuestions,
      'endingQuestionNumbers': endingQuestionNumbers,
      'endingQuestions': endingQuestions,
      'answers': answers,
    };
  }
}
class SentenceCompletion {
  final String id;
  final String sentence;
  String title;
  String initialQuestionNumbers;
  List initialQuestions;
  String endingQuestionNumbers;
  List endingQuestions;
  List answers;
  String level;
  final List<String> options;
  final String correctOption;

  SentenceCompletion({
    required this.id,
    required this.sentence,
    required this.initialQuestions,
    required this.initialQuestionNumbers,
    required this.endingQuestions,
    required this.endingQuestionNumbers,
    required this.answers,
    required this.level,
    required this.title,
    required this.options,
    required this.correctOption,
  });

  factory SentenceCompletion.fromMap(Map<String, dynamic> map, String id) {
    return SentenceCompletion(
      id: id,
      sentence: map['sentence'] ?? '',
      title: map['title'] ?? '',
      initialQuestionNumbers: map['initialQuestionNumbers'] ?? '',
      level: map['level'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      endingQuestionNumbers: map['endingQuestionNumbers'] ?? '',
      answers: List<String>.from(map['answers'] ?? []),
      endingQuestions: List<String>.from(map['endingQuestions'] ?? []),
      initialQuestions: List<String>.from(map['initialQuestions'] ?? []),
      correctOption: map['correctOption'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sentence': sentence,
      'options': options,
      'correctOption': correctOption,
      'title': title,
      'initialQuestionNumbers': initialQuestionNumbers,
      'initialQuestions': initialQuestions,
      'endingQuestionNumbers': endingQuestionNumbers,
      'answers': answers,
      'endingQuestions': endingQuestions,
      'level': level,
    };
  }
}
class SummaryCompletion {

  final String title;
  final String initialQuestionNumbers;
  List initialQuestions;
  final String endingQuestionNumbers;
  List endingQuestions;
  List answers;
  final String id;
  String level;
  SummaryCompletion( {

    required this.id,
    required this.title,
    required this.level,
    required this.initialQuestionNumbers,
    required this.initialQuestions,
    required this.endingQuestionNumbers,
    required this.answers,
    required this.endingQuestions,

  });
  // Factory method to create a SummaryCompletion instance from a map
  factory SummaryCompletion.fromMap(Map<String, dynamic> map, String id) {
    return SummaryCompletion(
      id: id,

      // options: (map['options'] as List<dynamic>?)
      //     ?.map((dynamic item) => item.toString())
      //     .toList() ?? [''],

      initialQuestionNumbers: map['initialQuestionNumbers'].toString(),
      initialQuestions: List<String>.from(map['initialQuestions']),
      endingQuestionNumbers: map['endingQuestionNumbers'] ?? '',
      endingQuestions: List<String>.from(map['endingQuestions']),
      answers: List<String>.from(map['answers']),

      level: map['level'].toString(),
      title: map['title'].toString(),


    );
  }

}
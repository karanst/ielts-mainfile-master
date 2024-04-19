
class HeadingCompletion {
  late final String id;

  String paragraph;
  String level;
  String title;
  List initialQuestions;
  String initialQuestionNumbers;
  String endingQuestionNumbers;
  List endingQuestions;
  List answers;


  HeadingCompletion({
    required this.id,
    required this.level,
    required this.initialQuestions,
    required this.initialQuestionNumbers,
    required this.title,
    required this.paragraph,
    required this.endingQuestions,
    required this.endingQuestionNumbers,
    required this.answers,

  });

  factory HeadingCompletion.fromMap(Map<String, dynamic> map, String documentId) {
    return HeadingCompletion(
      id: documentId,
      level: map['level'] ?? "",
      initialQuestionNumbers: map['initialQuestionNumbers'] ?? "",
      initialQuestions: List<String>.from(map['initialQuestions']),
      title: map['title'] ?? "",
      paragraph: map['paragraph'].toString(),
      endingQuestionNumbers: map['endingQuestionNumbers'].toString(),
      endingQuestions: List<String>.from(map['endingQuestions']),
      answers: List<String>.from(map['answers']),


    );
  }
}
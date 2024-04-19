class Reading {
  String id;
  String title;
  String level;
  int indicatorValue;
  List initialQuestions;
  List endingQuestions;
  String paragraph;
  List answers;
  String intialQuestionNumbers;
  String endingQuestionNumbers;
  String whatToDo;
  bool extraData;
  String summary;

  Reading({
  required  this.id,
  required  this.title,
  required  this.level,
  required  this.indicatorValue,
  required  this.initialQuestions,
  required  this.endingQuestions,
   required this.extraData,
  required  this.paragraph,
 required   this.answers,
  required  this.intialQuestionNumbers,
   required this.endingQuestionNumbers,
  required  this.whatToDo,
  required  this.summary,
  });

  Reading.fromMap(Map snapshot, String id)
      : id = snapshot['id'] ?? '',
        title = snapshot['title'] ?? '',
        level = snapshot['level'] ?? '',
        indicatorValue = snapshot['indicatorValue'] ?? '',
        initialQuestions = snapshot['initialQuestions'] ?? [],
        endingQuestions = snapshot['endingQuestions'] ?? [],
        extraData = snapshot['extraData'] ?? false,
        paragraph = snapshot['paragraph'] ?? '',
        answers = snapshot['answers'] ?? [],
        intialQuestionNumbers = snapshot['initialQuestionNumbers'] ?? '',
        endingQuestionNumbers = snapshot['endingQuestionNumbers'] ?? '',
        whatToDo = snapshot['whatToDo'] ?? '',
        summary = snapshot['summary'] ?? '';

  toJson() {
    return {
      "id": id,
      "title": title,
      "level": level,
      "indicatorValue": indicatorValue,
      "initialQuestions": initialQuestions,
      "endingQuestions": endingQuestions,
      "extraData": extraData,
      "paragraph": paragraph,
      "answers": answers,
      "initialQuestionNumbers": intialQuestionNumbers,
      "endingQuestionNumbers": endingQuestionNumbers,
      "whatToDo": whatToDo,
      "summary": summary,
    };
  }
}

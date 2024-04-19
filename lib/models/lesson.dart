// writing data
class Lesson {
  String id;
  String title;
  String level;
  int indicatorValue;
  String question;
  String answer;
  String image;

  Lesson(
      {required this.id,
        required this.title,
        required this.level,
        required this.indicatorValue,
        required  this.question,
        required this.answer,
        required this.image});

  Lesson.fromMap(Map snapshot, String id)
      : id = snapshot['id'] ?? '',
        title = snapshot['title'] ?? '',
        level = snapshot['level'] ?? '',
        indicatorValue = (snapshot['indicatorValue'] ?? 0).toInt(),
        question = snapshot['question'] ?? '',
        answer = snapshot['answer'] ?? '',
        image = snapshot['image'] ?? '';

  toJson() {
    return {
      "id": id,
      "title": title,
      "level": level,
      "indicatorValue": indicatorValue,
      "question": question,
      "answer": answer,
      "image": image,
    };
  }
}

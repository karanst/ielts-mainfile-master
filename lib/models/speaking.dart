class Speaking {
  String id;
  String title;
  String level;
  int indicatorValue;
  List thingsToSpeak;
  List vocabulary;
  String answer;

  Speaking({
    required this.id,
    required  this.title,
    required this.level,
    required this.indicatorValue,
    required  this.thingsToSpeak,
    required  this.vocabulary,
    required  this.answer,
  });

  // "thingsToSpeak": thingsToSpeak,
  Speaking.fromMap(Map<dynamic, dynamic> snapshot, String id)
      : id = snapshot['id'] ?? '',
        title = snapshot['title'] ?? '',
        level = snapshot['level'] ?? '',
        indicatorValue = snapshot['indicatorValue'] ?? '',
        // thingsToSpeak = snapshot['thingsToSpeak'] ?? '',
        thingsToSpeak = List.from(snapshot['thingsToSpeak'] ?? []),
        // vocabulary = snapshot['vocabulary'] ?? '',
        vocabulary = List.from(snapshot['vocabulary'] ?? []),
        answer = snapshot['answer'] ?? '';

  // "vocabulary": vocabulary,

  toJson() {
    return {
      "id": id,
      "title": title,
      "level": level,
      "thingsToSpeak": thingsToSpeak,
      "vocabulary": vocabulary,
      "indicatorValue": indicatorValue,
      "answer": answer,
    };
  }
}

class Listening {
  String id;
  String title;
  String level;
  int indicatorValue;
  String whatToDo;
  String firstSectionAudio;
  String firstQuestionImage;
  List s1SubQuestions1;
  bool s1SubQuestions1Bool;
  String s1SubQuestions1Numbers;

  String intialQuestionNumbers;

  bool s1SubQuestions2Bool;
  String s1SubQuestions2Numbers;
  List s1SubQuestions2;

  String secondQuestionImage;
  bool secondQuestionImageBool;

  List answers;

  //section 2
  String s2WhatToDo;
  String section2Audio;
  String section2Image1;
  bool section2Image1Bool;
  String section2Image2;
  bool section2Image2Bool;
  String s2SubQuestion1Numbers;
  List s2SubQuestions1;
  bool s2SubQuestions1Bool;
  String s2SubQuestion2Numbers;
  List s2SubQuestions2;
  bool s2SubQuestions2Bool;
  List section2Answers;

  // section 3

  String s3WhatToDo;
  String section3Audio;
  bool section3Image1Bool;
  String section3Image1;
  bool section3Image2bool;
  String section3Image2;
  bool section3Image3bool;
  String section3Image3;
  List section3Question1;
  bool section3Question1bool;
  String section3Question1Numbers;
  List section3Question2;
  bool section3Questions2bool;
  String section3Question2Numbers;
  List section3Question3;
  bool section3Question3bool;
  String section3Question3Numbers;
  List section3Answers;

  // section 4

  String s4WhatToDo;
  String section4Audio;
  String section4Question1Numbers;
  String section4Image1;
  bool section4Image1Bool;
  String section4Image2;
  bool section4Image2Bool;
  List section4Question1;
  bool section4Question1Bool;
  String section4Question2Numbers;
  List section4Question2;
  bool section4Question2Bool;
  String section4Question3Numbers;
  List section4Question3;
  bool section4Question3Bool;
  List section4Answers;

  Listening(
      {required this.id,
      required this.title,
      required this.level,
      required this.indicatorValue,
      required this.s1SubQuestions1,
      required this.firstSectionAudio,
      required this.firstQuestionImage,
      required this.s1SubQuestions1Bool,
      required this.s1SubQuestions1Numbers,
      required this.answers,
      required this.intialQuestionNumbers,
      required this.whatToDo,
      required this.s1SubQuestions2Bool,
      required this.s1SubQuestions2Numbers,
      required this.s1SubQuestions2,
      required this.secondQuestionImage,
      required this.secondQuestionImageBool,

      // section 2

      required this.s2WhatToDo,
      required this.section2Audio,
      required this.section2Image1,
      required this.section2Image1Bool,
      required this.section2Image2,
      required this.section2Image2Bool,
      required this.s2SubQuestion1Numbers,
      required this.s2SubQuestions1,
      required this.s2SubQuestions1Bool,
      required this.s2SubQuestion2Numbers,
      required this.s2SubQuestions2,
      required this.s2SubQuestions2Bool,
      required this.section2Answers,

      // section 3

      required this.s3WhatToDo,
      required this.section3Audio,
      required this.section3Image1,
      required this.section3Image1Bool,
      required this.section3Image2bool,
      required this.section3Image2,
      required this.section3Image3bool,
      required this.section3Image3,
      required this.section3Question1,
      required this.section3Question1Numbers,
      required this.section3Question1bool,
      required this.section3Question2,
      required this.section3Question2Numbers,
      required this.section3Questions2bool,
      required this.section3Question3,
      required this.section3Question3bool,
      required this.section3Question3Numbers,
      required this.section3Answers,

      // section4
      //
      required this.s4WhatToDo,
      required this.section4Audio,
      required this.section4Question1Numbers,
      required this.section4Question1,
      required this.section4Question1Bool,
      required this.section4Question2Numbers,
      required this.section4Question2,
      required this.section4Question2Bool,
      required this.section4Question3Numbers,
      required this.section4Question3,
      required this.section4Question3Bool,
      required this.section4Answers,
      required this.section4Image1,
      required this.section4Image1Bool,
      required this.section4Image2,
      required this.section4Image2Bool});

  Listening.fromMap(Map<dynamic, dynamic> snapshot, String id)
      : id = snapshot['id'] ?? '',
        title = snapshot['title'] ?? '',
        level = snapshot['level'] ?? '',
        s1SubQuestions1 = snapshot['s1SubQuestions1'] ?? [],
        indicatorValue = (snapshot['indicatorValue'] ?? 0).toInt(),
        s1SubQuestions1Bool = snapshot['s1SubQuestions1Bool'] ?? false,
        s1SubQuestions1Numbers = snapshot['s1SubQuestions1Numbers'] ?? '',
        firstSectionAudio = snapshot['firstSectionAudio'] ?? '',
        answers = snapshot['answers'] ?? [],
        intialQuestionNumbers = snapshot['initialQuestionNumbers'] ?? '',
        firstQuestionImage = snapshot['firstQuestionImage'] ?? '',
        whatToDo = snapshot['whatToDo'] ?? '',
        s1SubQuestions2Bool = snapshot['s1SubQuestions2Bool'] ?? false,
        s1SubQuestions2 = snapshot['s1SubQuestions2'] ?? [],
        s1SubQuestions2Numbers = snapshot['s1SubQuestions2Numbers'] ?? '',
        secondQuestionImage = snapshot['secondQuestionImage'] ?? '',
        secondQuestionImageBool = snapshot['secondQuestionImageBool'] ?? false,

        // section 2
        s2WhatToDo = snapshot['s2WhatToDo'] ?? '',
        section2Audio = snapshot['section2Audio'] ?? '',
        section2Image1 = snapshot['section2Image1'] ?? '',
        section2Image1Bool = snapshot['section2Image1Bool'] ?? false,
        section2Image2 = snapshot['section2Image2'] ?? '',
        section2Image2Bool = snapshot['section2Image2Bool'] ?? false,
        s2SubQuestion1Numbers = snapshot['s2SubQuestion1Numbers'] ?? '',
        s2SubQuestions1 = snapshot['s2SubQuestions1'] ?? [],
        s2SubQuestions1Bool = snapshot['s2SubQuestions1Bool'] ?? false,
        s2SubQuestion2Numbers = snapshot['s2SubQuestion2Numbers'] ?? '',
        s2SubQuestions2 = snapshot['s2SubQuestions2'] ?? [],
        s2SubQuestions2Bool = snapshot['s2SubQuestions2Bool'] ?? false,
        section2Answers = snapshot['section2Answers'] ?? [],

        // section 3

        s3WhatToDo = snapshot['s3WhatToDo'] ?? '',
        section3Audio = snapshot['section3Audio'] ?? '',
        section3Image1Bool = snapshot['section3Image1Bool'] ?? false,
        section3Image1 = snapshot['section3Image1'] ?? '',
        section3Image2bool = snapshot['section3Image2bool'] ?? false,
        section3Image2 = snapshot['section3Image2'] ?? '',
        section3Image3bool = snapshot['section3Image3bool'] ?? false,
        section3Image3 = snapshot['section3Image3'] ?? '',
        section3Question1 = snapshot['section3Question1'] ?? [],
        section3Question1bool = snapshot['section3Question1bool'] ?? false,
        section3Question1Numbers = snapshot['section3Question1Numbers'] ?? '',
        section3Question2 = snapshot['section3Question2'] ?? [],
        section3Questions2bool = snapshot['section3Questions2bool'] ?? false,
        section3Question2Numbers = snapshot['section3Question2Numbers'] ?? '',
        section3Question3 = snapshot['section3Question3'] ?? [],
        section3Question3bool = snapshot['section3Question3bool'] ?? false,
        section3Question3Numbers = snapshot['section3Question3Numbers'] ?? '',
        section3Answers = snapshot['section3Answers'] ?? [],

        // section 4

        s4WhatToDo = snapshot['s4WhatToDo'] ?? '',
        section4Audio = snapshot['section4Audio'] ?? '',
        section4Question1Numbers = snapshot['section4Question1Numbers'] ?? '',
        section4Question1 = snapshot['section4Question1'] ?? [],
        section4Question1Bool = snapshot['section4Question1Bool'] ?? false,
        section4Question2Numbers = snapshot['section4Question2Numbers'] ?? '',
        section4Question2 = snapshot['section4Question2'] ?? [],
        section4Question2Bool = snapshot['section4Question2Bool'] ?? false,
        section4Question3Numbers = snapshot['section4Question3Numbers'] ?? '',
        section4Question3 = snapshot['section4Question3'] ?? [],
        section4Question3Bool = snapshot['section4Question3Bool'] ?? false,
        section4Answers = snapshot['section4Answers'] ?? [],
        section4Image1 = snapshot['section4Image1'] ?? '',
        section4Image1Bool = snapshot['section4Image1Bool'] ?? false,
        section4Image2 = snapshot['section4Image2'] ?? '',
        section4Image2Bool = snapshot['section4Image2Bool'] ?? false;

  toJson() {
    return {
      "id": id,
      "title": title,
      "level": level,
      "indicatorValue": indicatorValue,
      "s1SubQuestions1": s1SubQuestions1,
      "s1SubQuestions1Bool": s1SubQuestions1Bool,
      "s1SubQuestions1Numbers": s1SubQuestions1Numbers,
      "firstSectionAudio": firstSectionAudio,
      "answers": answers,
      "intialQuestionNumbers": intialQuestionNumbers,
      "firstQuestionImage": firstQuestionImage,
      "whatToDo": whatToDo,
      "s1SubQuestions2Bool": s1SubQuestions2Bool,
      "s1SubQuestions2": s1SubQuestions2,
      "s1SubQuestions2Numbers": s1SubQuestions2Numbers,
      "secondQuestionImage": secondQuestionImage,
      "secondQuestionImageBool": secondQuestionImageBool,

      // section 2
      "s2WhatToDo": s2WhatToDo,
      "section2Audio": section2Audio,
      "section2Image1": section2Image1,
      "section2Image1Bool": section2Image1Bool,
      "section2Image2": section2Image2,
      "section2Image2Bool": section2Image2Bool,
      "s2SubQuestion1Numbers": s2SubQuestion1Numbers,
      "s2SubQuestions1": s2SubQuestions1,
      "s2SubQuestions1Bool": s2SubQuestions1Bool,
      "s2SubQuestion2Numbers": s2SubQuestion2Numbers,
      "s2SubQuestions2": s2SubQuestions2,
      "s2SubQuestions2Bool": s2SubQuestions2Bool,
      "section2Answers": section2Answers,

      // section 3

      "s3WhatToDo": s3WhatToDo,
      "section3Audio": section3Audio,
      "section3Image1Bool": section3Image1Bool,
      "section3Image1": section3Image1,
      "section3Image2bool": section3Image2bool,
      "section3Image2": section3Image2,
      "section3Image3bool": section3Image3bool,
      "section3Image3": section3Image3,
      "section3Question1": section3Question1,
      "section3Question1bool": section3Question1bool,
      "section3Question1Numbers": section3Question1Numbers,
      "section3Question2": section3Question2,
      "section3Questions2bool": section3Questions2bool,
      "section3Question2Numbers": section3Question2Numbers,
      "section3Question3": section3Question3,
      "section3Question3bool": section3Question3bool,
      "section3Question3Numbers": section3Question3Numbers,
      "section3Answers": section3Answers,

      // section 4

      "s4WhatToDo": s4WhatToDo,
      "section4Audio": section4Audio,
      "section4Question1Numbers": section4Question1Numbers,
      "section4Question1": section4Question1,
      "section4Question1Bool": section4Question1Bool,
      "section4Question2Numbers": section4Question2Numbers,
      "section4Question2": section4Question2,
      "section4Question2Bool": section4Question2Bool,
      "section4Question3Numbers": section4Question3Numbers,
      "section4Question3": section4Question3,
      "section4Question3Bool": section4Question3Bool,
      "section4Answers": section4Answers,
      "section4Image1": section4Image1,
      "section4Image1Bool": section4Image1Bool,
      "section4Image2": section4Image2,
      "section4Image2Bool": section4Image2Bool,
    };
  }
}

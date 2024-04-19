import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ielts/models/quiz.dart';
import 'package:ielts/screens/quiz_result_screen.dart';

import '../widgets/facebookAds.dart';

class QuizDetailScreen extends StatefulWidget {
  final Quiz quiz;
  QuizDetailScreen({required this.quiz});

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  var parser = EmojiParser();
  late List<String> options = [];
  var _selectedAnswer;
  int answerScore = 0;
  String _answer = '';
  int _currentIndex = 0;
  MyAds ads = MyAds();

  @override
  void initState() {
    super.initState();

    // Set options for the first question
    setOptionsForCurrentQuestion();
  }

  void setOptionsForCurrentQuestion() {
    if (widget.quiz.questions.isNotEmpty) {
      final currentQuestion = widget.quiz.questions[_currentIndex];
      options = List<String>.from(currentQuestion.options);
      print("Options: $options");
    } else {
      print("Questions not available for quiz");
      // Handle the case when questions are not available (set a default or show an error message).
    }
  }

  _onChanged(int? value) {
    setState(() {
      _selectedAnswer = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;

    ScreenUtil.init(context);

    return GestureDetector(
      onTap: () {
        print("GestureDetector tapped");
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 100, // Adjust the height according to your banner ad's size
            alignment: Alignment.center,
            child: ads.buildBannerAd(), // Display the banner ad
          ),
        ),
        backgroundColor: Theme.of(context).splashColor,
        key: _key,
        appBar: AppBar(
          backgroundColor: Theme.of(context).indicatorColor,
          title: FittedBox(
            child: Text(
              widget.quiz.quizTitle ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).indicatorColor),
                  height: screenHeight / 4,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(16)),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: Text(
                            "${_currentIndex + 1}",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(16)),
                        Expanded(
                          child: Text(
                            widget.quiz.questions?[_currentIndex]?.questionText ??
                                '',
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(18),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(25)),
                    Card(
                      elevation: 8,
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(12),
                          horizontal: ScreenUtil().setWidth(12),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: options.length ?? 0,
                          itemBuilder: (context, index) {
                            if (index >= options.length) {
                              return SizedBox
                                  .shrink(); // Return an empty SizedBox if options are null or index is out of bounds
                            }

                            return Padding(
                              padding:
                                  EdgeInsets.only(top: ScreenUtil().setHeight(8)),
                              child: RadioListTile<int>(
                                groupValue: _selectedAnswer,
                                activeColor: (_selectedAnswer != null &&
                                        _selectedAnswer == index)
                                    ? Colors.white
                                    : Colors.white,
                                title: Text(
                                  options[index],
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontSize: ScreenUtil().setSp(15),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                value: index,
                                onChanged: (int? value) => _onChanged(value),
                                tileColor: Colors.transparent,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Column(
                      children: <Widget>[
                        Visibility(
                          visible: _answer.isNotEmpty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(8)),
                                child: Text(
                                  (_answer == 'Answer is right, well done!')
                                      ? '${parser.emojify(':wink:')}'
                                      : '${parser.emojify(':disappointed:')} ',
                                  style:
                                      TextStyle(fontSize: ScreenUtil().setSp(36)),
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(220),
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                decoration: BoxDecoration(
                                  color:
                                      (_answer == 'Answer is right, well done!')
                                          ? Colors.lightGreen
                                          : Colors.redAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    _answer,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(14),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: _answer == 'Wrong Answer, try again',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(8)),
                                child: Text(
                                  parser.emojify(':heart:'),
                                  style:
                                      TextStyle(fontSize: ScreenUtil().setSp(36)),
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(220),
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SizedBox(),
                                // Text(
                                //   ' Correct Answer is ${widget.quiz.questions![_currentIndex]?.options[widget.quiz.questions![_currentIndex]?.correctOptionIndex ?? 0]} ',
                                //
                                //   maxLines: 5,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: ScreenUtil().setSp(16),
                                //     fontFamily: 'Montserrat',
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _currentIndex == (widget.quiz.questions!.length - 1)
                            ? "Submit"
                            : "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      color: Colors.deepPurpleAccent,
                      onPressed: () {
                        print("Submit/Next button pressed");
                        _nextSubmit();
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _onWillPop() async {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(
              "Are you sure you want to quit the quiz? All your progress will be lost."),
          title: Text("Warning!"),
          actions: <Widget>[
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                print(answerScore);
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
  bool isNavigationInProgress = false;

  void _nextSubmit() {
    print('Entering _nextSubmit function');

    if (isNavigationInProgress) {
      print('Navigation already in progress. Ignoring button press.');
      return;
    }

    if (_selectedAnswer == null) {
      // Show a SnackBar if no answer is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must select an option to continue.'),
        ),
      );
      print('No answer selected');
      return;
    }

    setState(() {
      final currentQuestion = widget.quiz.questions[_currentIndex];
      final correctOptionIndex = currentQuestion.correctOptionIndex;

      print('Selected Answer: $_selectedAnswer');
      print('Correct Option Index: $correctOptionIndex');

      if (_selectedAnswer == correctOptionIndex) {
        answerScore++;
        _answer = 'Answer is right, well done!';
        print('Correct answer!');
      } else {
        _answer = 'Wrong Answer, try again';
        print('Wrong answer');
      }

      if (_currentIndex < (widget.quiz.questions.length - 1)) {
        print('Moving to the next question');
        _currentIndex++;
        setOptionsForCurrentQuestion(); // Call the method to set options for the current question
        _selectedAnswer = null;
        _answer = '';
      } else {
        // Set flag to indicate navigation is in progress
        isNavigationInProgress = true;
        ads.showRewardedAd();
        // Wait for a short duration to show the result message before navigating
        Future.delayed(Duration(milliseconds: 2000), () {

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => QuizResultScreen(
                quizScore: answerScore,
                totalQuestions: widget.quiz.questions.length,
                questions: widget.quiz.questions,
                correctOptionIndices: widget.quiz.questions
                    .map((question) => question.correctOptionIndex)
                    .toList(),
              ),
            ),
          );

          print('Navigating to result screen');
        });
      }
    });

    print('Exiting _nextSubmit function');
  }







}

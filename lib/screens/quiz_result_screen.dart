import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ielts/utils/app_constants.dart';
import 'package:ielts/widgets/adsHelper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/quiz.dart';

class QuizResultScreen extends StatefulWidget {
  final int quizScore;
  final int totalQuestions;
  final List<Question> questions;
  final List<int> correctOptionIndices;

  QuizResultScreen({
    required this.quizScore,
    required this.totalQuestions,
    required this.questions,
    required this.correctOptionIndices,
  });

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool showAnswers = false;
  String resultText = '';
  double scoreInDouble = 0.0;

  void _resultText() {
    if (scoreInDouble >= 0.8) {
      resultText = 'Keep on learning!';
    } else if (scoreInDouble >= 0.6) {
      resultText = 'You can do better!';
    } else if (scoreInDouble < 0.6) {
      resultText = 'Review the answers for better understanding';
    }
  }

  void scoreConverter() {
    scoreInDouble = widget.quizScore / widget.totalQuestions.toDouble();
  }

  @override
  void initState() {
    scoreConverter();
    _resultText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.popAndPushNamed(context, RoutePaths.quiz),
        isExtended: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Icon(Icons.fast_forward),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(0, 65, 106, 1),
                Color.fromRGBO(228, 229, 230, 1),
              ],
            ),
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: showAnswers
                    ? EdgeInsets.only(top: ScreenUtil().setHeight(30))
                    : EdgeInsets.only(top: ScreenUtil().setHeight(80)),
                child: Center(
                  child: CircularPercentIndicator(
                    radius: ScreenUtil().setWidth(100),
                    lineWidth: ScreenUtil().setWidth(16),
                    animation: true,
                    percent: scoreInDouble,
                    center: Text(
                      '${widget.quizScore}/${widget.totalQuestions}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    ),
                    footer: Text(
                      'Your Score',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(24),
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.purple,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Column(
                children: <Widget>[
                  Visibility(
                    visible: showAnswers == false,
                    child: Container(
                      height: ScreenUtil().setHeight(120),
                      width: ScreenUtil().setWidth(250),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (scoreInDouble < 0.6)
                              ? AssetImage('assets/pushing.png')
                              : AssetImage('assets/success.png'),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: (scoreInDouble > 0.6)
                            ? 'Well Done!'
                            : ' Not Good,\n Keep Pushing!',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          color:
                              (scoreInDouble < 0.6) ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Center(
                      child: Text(
                        resultText,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                          color:
                              (scoreInDouble < 0.6) ? Colors.red : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Review Answers',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(
                      width: 10), // Add some spacing between text and switch
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        AdHelper.showInterstitialAd(onComplete: () {
                          showAnswers = !showAnswers;
                        });
                        // Toggle the value
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: showAnswers ? Colors.blue : Colors.grey,
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: showAnswers ? 20 : 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.check,
                                color: showAnswers ? Colors.blue : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showAnswers,
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(14)),
                  child: Text(
                    'Answers Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showAnswers,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: widget.questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(10),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                      ),
                      child: Card(
                        color: Color.fromRGBO(57, 106, 137, 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20),
                            vertical: ScreenUtil().setHeight(10),
                          ),
                          leading: Container(
                            padding: EdgeInsets.only(
                              right: ScreenUtil().setWidth(12),
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 1.0,
                                  color: Colors.white24,
                                ),
                              ),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(16),
                              ),
                            ),
                          ),
                          title: Text(
                            widget.questions[index].questionText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(16),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(20),
                            ),
                            child: Text(
                              'Answer: ${widget.questions[index].options[widget.correctOptionIndices[index]]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

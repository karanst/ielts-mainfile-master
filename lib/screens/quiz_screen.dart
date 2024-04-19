import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_grouped_buttons/flut_grouped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/screens/quiz_detail_screen.dart';
import 'package:ielts/services/admob_service.dart';
import 'package:ielts/models/quiz.dart'; // Assuming your Quiz model is in a file named quiz.dart
import 'package:ielts/widgets/adsHelper.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../utils/app_constants.dart';
import '../widgets/facebookAds.dart';
import '../widgets/menu_page.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final double _borderRadius = 24;
  final ams = AdMobService();
  MyAds ads = MyAds();
  int _currentIndex = 0;
  int _scoresIndex = 0;
  List<Quiz>? quizzes;
  final _adController = NativeAdController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    return Scaffold(
      bottomNavigationBar:
          _adController.ad != null && _adController.adLoaded.isTrue
              ? SizedBox(
                  height: 100,
                  child: AdWidget(
                      ad: _adController.ad!), // Create and load a new ad object
                )
              : null,
      // bottomNavigationBar: BottomAppBar(
      //   child: Container(
      //     height: 100, // Adjust the height according to your banner ad's size
      //     alignment: Alignment.center,
      //     child: ads.buildBannerAd(), // Display the banner ad
      //   ),
      // ),
      backgroundColor: Theme.of(context).splashColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).indicatorColor,
        title: Text(
          'Quiz Screen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => MenuPage(userId: userId));
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).indicatorColor,
              ),
              height: ScreenUtil().setHeight(200),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(40),
              left: ScreenUtil().setWidth(10),
              right: ScreenUtil().setWidth(10),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('quiz').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  quizzes = snapshot.data?.docs
                      .map((doc) => Quiz.fromMap(
                            doc.data() as Map<String, dynamic>,
                            doc.id,
                          ))
                      .toList();

                  return ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: quizzes?.length ?? 0,
                    itemBuilder: (context, index) {
                      _scoresIndex = _scoresIndex + 1;
                      _currentIndex = _currentIndex + 1;
                      return _inkwell(quizzes![index]);
                    },
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inkwell(Quiz quiz) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizDetailScreen(quiz: quiz),
          ),
        );
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(16)),
          child: Stack(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  gradient: _color(),
                  boxShadow: [
                    _boxShadowColor(),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  size: Size(
                    ScreenUtil().setHeight(100),
                    ScreenUtil().setHeight(150),
                  ),
                  painter: CustomCardShapePainter(
                    _borderRadius,
                    items[_currentIndex % items.length].startColor,
                    items[_currentIndex % items.length].endColor,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          'assets/quiz.png',
                          height: ScreenUtil().setHeight(64),
                          width: ScreenUtil().setWidth(64),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        flex: 8,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                quiz.quizTitle ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(15)),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.cached,
                                    color: Colors.white,
                                    size: ScreenUtil().setHeight(16),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(5),
                                  ),
                                  Text(
                                    'Total Questions: ${quiz.questions?.length}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: ScreenUtil().setSp(14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          padding: EdgeInsets.all(20),
                          child: FlutGroupedButtons(
                            data: [quiz.id ?? ''],
                            labelStyle: TextStyle(fontSize: 0),
                            onChanged: (index) {
                              // Handle the onChanged event as needed
                              // This is triggered when the button state changes
                              bool isCorrect = (index ==
                                  quiz.questions[_currentIndex]
                                      .correctOptionIndex);
                              String message = isCorrect
                                  ? 'Correct! Well done!'
                                  : 'Incorrect. Try again!';

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _color() {
    return LinearGradient(
      colors: [
        items[_currentIndex % items.length].startColor,
        items[_currentIndex % items.length].endColor,
      ],
    );
  }

  BoxShadow _boxShadowColor() {
    return BoxShadow(
      color: items[_currentIndex % items.length].endColor,
      blurRadius: 12,
      offset: Offset(0, 6),
    );
  }
}

// Add this list of GradientColors at the beginning of your _QuizScreenState class
List<GradientColors> items = [
  GradientColors(
    Color(0xff6DC8F3),
    Color(0xff73A1F9),
  ),
  GradientColors(
    Color(0xffFFB157),
    Color(0xffFFA057),
  ),
  GradientColors(
    Color(0xffFF5B95),
    Color(0xffF8556D),
  ),
  GradientColors(
    Color(0xffD76EF5),
    Color(0xff8F7AFE),
  ),
  GradientColors(
    Color(0xff42E695),
    Color(0xff3BB2B8),
  ),
];

class GradientColors {
  final Color startColor;
  final Color endColor;

  GradientColors(
    this.startColor,
    this.endColor,
  );
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = ScreenUtil().setWidth(12);

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

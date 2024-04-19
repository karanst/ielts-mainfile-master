import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ielts/models/mcqs.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/premium_screen.dart';
import 'package:ielts/widgets/adsHelper.dart';

import '../widgets/facebookAds.dart';

class MCQDetailScreen extends StatefulWidget {
  final MCQs reading;

  MCQDetailScreen({required this.reading});

  @override
  _MCQDetailScreenState createState() => _MCQDetailScreenState(reading);
}

class _MCQDetailScreenState extends State<MCQDetailScreen> {
  final MCQs reading;
  _MCQDetailScreenState(this.reading);
  MyAds ads = MyAds();
  int? selectedOption;
  bool showColoredBox = false;
  var initialQuestionResult;
  var endingQuestionResult;
  var answersResult;
  var allAnswers;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    selectedOption = null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 100, // Adjust the height according to your banner ad's size
          alignment: Alignment.center,
          child: ads.buildBannerAd(), // Display the banner ad
        ),
      ),
      appBar: AppBar(
        title: Text(
          reading.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(18),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: 0.0,
      ),
      body: Material(
        animationDuration: duration,
        elevation: 8,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).secondaryHeaderColor,
                        blurRadius: 10,
                      ),
                    ],
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(75)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(40),
                      ),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(ScreenUtil().setHeight(12)),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reading.initialQuestionNumbers.toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Color(0xFF21BFBD),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reading.initialQuestions.length,
                              itemBuilder: (BuildContext context, int index) {
                                initialQuestionResult =
                                    reading.initialQuestions[index];

                                return ListTile(
                                  title: Text(
                                    initialQuestionResult.replaceAll(
                                        "_n", "\n"),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(13),
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              },
                            )),
                        // Padding for Ending Question Numbers
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(ScreenUtil().setHeight(12)),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reading.endingQuestionNumbers ?? "",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Color(0xFF21BFBD),
                                ),
                              ),
                            ],
                          ),
                        ),

// ListView for Ending Questions
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reading.endingQuestions.length,
                          itemBuilder: (BuildContext context, int index) {
                            endingQuestionResult =
                                reading.endingQuestions[index];
                            return Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(10)),
                              child: Container(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    endingQuestionResult.replaceAll("_n", "\n"),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      fontSize: ScreenUtil().setSp(13),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Container(
                  color: Colors.deepPurpleAccent,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      onPressed: () {
                        // Check if the user is premium
                        if (!premium_user_google_play) {
                          // User is premium, show the answer
                          AdHelper.showRewardedAd(onComplete: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomPopupDialog(
                                    reading); // Your custom dialog widget
                              },
                            );
                          });
                        } else {
                          // User is not premium, prompt to upgrade
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Upgrade to Premium"),
                                content: Text(
                                    "Upgrade to premium at very low price to see the answer."),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.red,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      // Redirect to Premium Screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PremiumScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Upgrade",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      // onPressed: () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return CustomPopupDialog(
                      //           reading); // Your custom dialog widget
                      //     },
                      //   );
                      // },
                      child: Text(
                        'Answers',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      color: Colors.deepPurpleAccent,
                      textColor: Colors.white,
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var answersResult;
MyAds ads = MyAds();

class CustomPopupDialog extends StatelessWidget {
  final MCQs reading;
  CustomPopupDialog(this.reading);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose an option"),
      content: Text("Do you want to CHeck the answer?"),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Show rewarded ad
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.red,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // Add your logic for Cancel button here

            if (reading.answers != null) {
              openBookingDetailsSheet(context, reading as MCQs);
            } else {
              // Show an error message or handle the case where
              // the user hasn't selected True or False
              // For example, you can display a SnackBar:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please select True or False.'),
              ));
            }
          },
          child: Text(
            "Check",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  void openBookingDetailsSheet(BuildContext context, MCQs reading) {
    showModalBottomSheet<Widget>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.all(16.0), // Add padding for better spacing
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Answers Sheets", // Add a title for the sheet
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0), // Add some vertical space
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reading.answers.length,
                itemBuilder: (BuildContext context, int index) {
                  String answersResult = reading.answers[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          answersResult.replaceAll("_n", "\n"),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}




/*
Padding(
padding: EdgeInsets.all(ScreenUtil().setWidth(0)),
child: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SizedBox(height: ScreenUtil().setHeight(20)),
Container(
height: MediaQuery.of(context).size.height,
decoration: BoxDecoration(
boxShadow: [
BoxShadow(
color: Theme.of(context).secondaryHeaderColor,
blurRadius: 10,
)
],
color: Theme.of(context).canvasColor,
borderRadius: BorderRadius.only(
topLeft: Radius.circular(ScreenUtil().setWidth(75)),
),
),
child: Padding(
padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SizedBox(height: ScreenUtil().setHeight(20)),
Text(
widget.reading.question,
style: TextStyle(
fontFamily: 'Montserrat',
fontWeight: FontWeight.bold,
fontSize: ScreenUtil().setSp(20),
color: Color(0xFF21BFBD),
),
),
SizedBox(height: ScreenUtil().setHeight(20)),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: List.generate(
widget.reading.options.length,
(index) => CheckboxListTile(
title: Text(widget.reading.options[index]),
value: selectedOption == index,
onChanged: (value) {
setState(() {
selectedOption = value! ? index : null;
});
},
controlAffinity:
ListTileControlAffinity.leading,
),
),
),
SizedBox(height: ScreenUtil().setHeight(20)),
Padding(
padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
child: Text(
'Correct Option',
style: TextStyle(
fontFamily: 'Montserrat',
fontWeight: FontWeight.bold,
fontSize: ScreenUtil().setSp(20),
color: Color(0xFF21BFBD),
),
),
),
Align(
alignment: Alignment.bottomCenter,
child: MaterialButton(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10)),
onPressed: () {
setState(() {
showColoredBox = true;
});
},
child: Text('Answer',
style: TextStyle(
fontSize: ScreenUtil().setSp(20),
fontFamily: 'Montserrat',
)),
color: Colors.deepPurpleAccent,
textColor: Colors.white,
elevation: 5,
),
),
if (showColoredBox)
Center(
child: ColoredBox(
color: Colors.blue.shade300,
child: Padding(
padding: EdgeInsets.all(ScreenUtil().setHeight(16)),
child: Text(
widget.reading.correctAnswerIndex.toString(),
style: TextStyle(
fontSize: ScreenUtil().setSp(16),
),
),
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
)*/

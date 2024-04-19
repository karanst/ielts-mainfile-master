import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ielts/models/sentencecompletion.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/premium_screen.dart';
import 'package:ielts/widgets/adsHelper.dart';

import '../widgets/facebookAds.dart';

class SentenceCompletionDetailScreen extends StatefulWidget {
  final SentenceCompletion reading;

  SentenceCompletionDetailScreen({required this.reading});

  @override
  _SentenceCompletionDetailScreenState createState() =>
      _SentenceCompletionDetailScreenState(this.reading);
}

class _SentenceCompletionDetailScreenState
    extends State<SentenceCompletionDetailScreen> {
  late SentenceCompletion reading;
  _SentenceCompletionDetailScreenState(this.reading);
  late List<bool> selectedOptions;
  MyAds ads = MyAds();
  bool showColoredBox = false;
  var initialQuestionResult;
  var endingQuestionResult;
  var answersResult;
  var allAnswers;
  final Duration duration = const Duration(milliseconds: 300);
  @override
  void initState() {
    super.initState();

    selectedOptions =
        List.generate(widget.reading.options.length, (index) => false);
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
          reading.title ?? "",
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
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
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

                        // Container for Ending Question Numbers
                        // Container for Ending Question Numbers
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   "Ending Question Numbers",
                              //   style: TextStyle(
                              //     fontFamily: 'Montserrat',
                              //     fontWeight: FontWeight.w600,
                              //     fontSize: 16,
                              //     color: Color(0xFF21BFBD),
                              //   ),
                              // ),
                              SizedBox(height: 8),
                              Text(
                                reading.endingQuestionNumbers.toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF21BFBD),
                                ),
                              ),
                            ],
                          ),
                        ),

// Container for Each Ending Question
                        Column(
                          children: reading.endingQuestions
                              .map((endingQuestionResult) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
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
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        // Radio buttons for True/False
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
                            // CustomPopupDialog(reading);
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
                                    "Upgrade to premium at avery low price to see the answer."),
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

  void openBookingDetailsSheet(
      BuildContext context, SentenceCompletion reading) {
    showModalBottomSheet<Widget>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) => ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reading.answers.length,
                itemBuilder: (BuildContext context, int index) {
                  answersResult = reading.answers[index];
                  return ListTile(
                    title: Text(
                      answersResult.replaceAll("_n", "\n"),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: ScreenUtil().setSp(13),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              )),
          // Additional validation based on isTrue property
          // if (reading.answers.length==1)
          //   Container(
          //     padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
          //     child: Text(
          //       'Congratulations! Your answer is correct.',
          //       style: TextStyle(
          //         fontFamily: 'Montserrat',
          //         fontSize: ScreenUtil().setSp(16),
          //         fontWeight: FontWeight.bold,
          //         color: Colors.green,
          //       ),
          //     ),
          //   ),
          // if (!reading.answers.isEmpty)
          //   Container(
          //     padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
          //     child: Text(
          //       'Oops! Your answer is incorrect.',
          //       style: TextStyle(
          //         fontFamily: 'Montserrat',
          //         fontSize: ScreenUtil().setSp(16),
          //         fontWeight: FontWeight.bold,
          //         color: Colors.red,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

var answersResult;
MyAds ads = MyAds();

class CustomPopupDialog extends StatelessWidget {
  final SentenceCompletion reading;
  CustomPopupDialog(this.reading);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose an option"),
      content: Text("Do you want to check the answer?"),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // // Add your logic for Cancel button here
            // // AdHelper.showRewardedAd(onComplete: () {});
            // // ads.showRewardedAd();
            // if (reading.answers != null) {
            //   openBookingDetailsSheet(context, reading as SentenceCompletion);
            // } else {
            //   // Show an error message or handle the case where
            //   // the user hasn't selected True or False
            //   // For example, you can display a SnackBar:
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text('Please select True or False.'),
            //   ));
            // }
            // // Show rewarded ad
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
            // AdHelper.showRewardedAd(onComplete: () {});
            // ads.showRewardedAd();
            if (reading.answers != null) {
              openBookingDetailsSheet(context, reading as SentenceCompletion);
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

  void openBookingDetailsSheet(
      BuildContext context, SentenceCompletion reading) {
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
                "Answer Sheet", // Add a title for the sheet
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

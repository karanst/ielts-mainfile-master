import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/models/trueorfalse.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/premium_screen.dart';
import 'package:ielts/services/admob_service.dart';
import 'package:ielts/widgets/adsHelper.dart';

import '../models/reading.dart';
import '../widgets/facebookAds.dart';

final Color backgroundColor = Color(0xFF21BFBD);

class ReadingDetailScreen extends StatefulWidget {
  late final TrueOrFalse reading;

  ReadingDetailScreen({
    required this.reading,
  });

  @override
  _ReadingDetailScreenState createState() => _ReadingDetailScreenState(reading);
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _ReadingDetailScreenState extends State<ReadingDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TrueOrFalse reading;

  _ReadingDetailScreenState(this.reading);

  var initialQuestionResult;
  var endingQuestionResult;
  var answersResult;
  var allAnswers;
  MyAds ads = MyAds();
  final ams = AdMobService();
  bool isCollapsed = true;
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    ams.getAdMobAppId();
    // AdHelper.showRewardedAd(onComplete: (){});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 100, // Adjust the height according to your banner ad's size
          alignment: Alignment.center,
          child: ads.buildBannerAd(), // Display the banner ad
        ),
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          reading.title ?? "",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: 0.0,
      ),
      body: Material(
        animationDuration: duration,
        elevation: 8,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Container for the main content
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
                                reading.whatToDo.toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(16),
                                  color: Color(0xFF21BFBD),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reading.paragraph.toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Color(0xFF21BFBD),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reading.initialQuestionNumbers.toString(),
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
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

                        // For Summary Text
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFF21BFBD)
                                .withOpacity(0.1), // Light background color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            reading.summary.replaceAll("_n", "\n"),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF21BFBD),
                              fontSize: 16,
                            ),
                          ),
                        ),

// For List of Questions
                        Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4, // Add elevation for a card-like effect
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: reading.endingQuestions.length,
                            itemBuilder: (BuildContext context, int index) {
                              endingQuestionResult =
                                  reading.endingQuestions[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
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
                                  // Add your TrueFalseRow widget here if needed
                                ),
                              );
                            },
                          ),
                        ),

                        // Radio buttons for True/False
                      ],
                    ),
                  ),
                ),

                // Container for the Answers button
                Container(
                  color: Colors.deepPurpleAccent,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // onPressed: () {
                      //   showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return CustomPopupDialog(
                      //           reading); // Your custom dialog widget
                      //     },
                      //   );
                      // },

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
                      elevation: 7,
                    ),
                  ),
                ),

                // Additional UI elements for true/false strategies
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.blue, // Change color as needed
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   margin: EdgeInsets.all(10),
                //   padding: EdgeInsets.all(10),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'True/False Strategies',
                //         style: TextStyle(
                //           fontFamily: 'Montserrat',
                //           fontWeight: FontWeight.bold,
                //           fontSize: ScreenUtil().setSp(18),
                //           color: Colors.white, // Change color as needed
                //         ),
                //       ),
                //       SizedBox(height: 10),
                //       Text(
                //         '1. Read the statements carefully.',
                //         style: TextStyle(
                //           fontFamily: 'Montserrat',
                //           fontSize: ScreenUtil().setSp(16),
                //           color: Colors.white, // Change color as needed
                //         ),
                //       ),
                //       Text(
                //         '2. Identify keywords in each statement.',
                //         style: TextStyle(
                //           fontFamily: 'Montserrat',
                //           fontSize: ScreenUtil().setSp(16),
                //           color: Colors.white, // Change color as needed
                //         ),
                //       ),
                //       Text(
                //         '3. Pay attention to negations like "not" or "never".',
                //         style: TextStyle(
                //           fontFamily: 'Montserrat',
                //           fontSize: ScreenUtil().setSp(16),
                //           color: Colors.white, // Change color as needed
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
  final TrueOrFalse reading;
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
            // Add your logic for Cancel button here

            // ads.showRewardedAd();

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
              openBookingDetailsSheet(context, reading as TrueOrFalse);
            } else {
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

  void openBookingDetailsSheet(BuildContext context, TrueOrFalse reading) {
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
                "Answer Sheets", // Add a title for the sheet
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

  // static void showRewardedAd({required VoidCallback onComplete}) {
  //   RewardedAd.load(
  //     adUnitId: 'ca-app-pub-3940256099942544/5224354917',
  //     request: AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (RewardedAd ad) {
  //         // log('Load Ads');
  //         // If you're using Get, uncomment this line
  //         // Get.back();
  //
  //         ad.show(
  //           onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
  //             // log("User earned the reward ${rewardItem.amount} ${rewardItem.type}");
  //             onComplete();
  //           },
  //         );
  //
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdShowedFullScreenContent: (ad) {},
  //           onAdFailedToShowFullScreenContent: (ad, error) {
  //             // If you're using Get, uncomment this line
  //             // Get.back();
  //             // log('Failed to show full screen content: $error');
  //             onComplete();
  //           },
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             // If you're using Get, uncomment this line
  //             // Get.back();
  //             onComplete();
  //           },
  //           onAdImpression: (ad) {
  //             print('$ad Ad Impression');
  //           },
  //         );
  //       },
  //       onAdFailedToLoad: (err) {
  //         // If you're using Get, uncomment this line
  //         // Get.back();
  //         // log('Failed to load a rewarded ad: ${err.message}');
  //       },
  //     ),
  //   );
  // }
}

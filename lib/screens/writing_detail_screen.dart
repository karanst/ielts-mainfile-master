// import 'package:admob_flutter/admob_flutter.dart';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ielts/models/lesson.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/premium_screen.dart';
import 'package:ielts/screens/writing_test_page.dart';
import 'package:ielts/services/admob_service.dart';
import 'package:ielts/widgets/adsHelper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/facebookAds.dart';

final Color backgroundColor = Color(0xFF21BFBD);
bool premium_user_google_play = false;

class WritingDetailScreen extends StatefulWidget {
  final Lesson lesson;
  WritingDetailScreen({
    // Key key,
    required this.lesson,
  });

  @override
  _WritingDetailScreenState createState() => _WritingDetailScreenState();
}

class _WritingDetailScreenState extends State<WritingDetailScreen>
    with SingleTickerProviderStateMixin {
  // final Lesson lesson;
  // _WritingDetailScreenState(this.lesson);

  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  // final ams = AdMobService();

  late BannerAd bannerAds;
  bool isAdLoaded = false;
  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-2565086294001704/2881838616'
      : 'ca-app-pub-2565086294001704/2881838616';
  // final String _adUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/2247696110'
  //     : 'ca-app-pub-3940256099942544/3986624511';

  /// Loads a native ad.
  void loadAd() {
    nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: Colors.teal,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  // var adUnits = 'ca-app-pub-2565086294001704/2881838616'; // Native ad unit ID
  var adUnit = 'ca-app-pub-2565086294001704/8844512703'; // Banner ad unit ID

  initBannerAd() {
    bannerAds = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            log('The ad has been loaded.');
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          log('Failed to load an ad: ${error.code}:${error.message}');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );

    // Load the banner ad
    bannerAds.load();
  }

  @override
  void initState() {
    super.initState();
    // Admob.initialize();
    initBannerAd();
    loadAd();
  }

  @override
  void dispose() {
    nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

//If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
//     ScreenUtil.init(context, width: 414, height: 896);

//If you want to set the font size is scaled according to the system's "font size" assist option
//     ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: bannerAds.size.height.toDouble(),
              width: bannerAds.size.width.toDouble(),
              child: AdWidget(ad: bannerAds),
            )
          : SizedBox(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(widget.lesson.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(18))),
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: 0.0,
      ),
      body: Material(
        animationDuration: duration,
        // borderRadius: BorderRadius.all(Radius.circular(40)),
        elevation: 8,
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: ScreenUtil().setHeight(40)),
                Container(
                    // height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).secondaryHeaderColor,
                            blurRadius: 10)
                      ],
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(75))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(
                            top: ScreenUtil()
                                .setHeight(ScreenUtil().setHeight(40))),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 8,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Question',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(20),
                                          color: Color(0xFF21BFBD)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setHeight(10)),
                                    child: Text(
                                      widget.lesson.question
                                          .replaceAll("_n", "\n"),
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(16),
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // ads.buildNativeAd(),
                          Container(
                            child: _nativeAdIsLoaded
                                ? SizedBox(
                                    child: Container(
                                      child: AdWidget(
                                        ad: nativeAd!,
                                      ),
                                      alignment: Alignment.center,
                                      height: 170,
                                      color: Colors.black12,
                                    ),
                                  )
                                : SizedBox(),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.lesson.image,
                                  placeholder: (context, url) => SizedBox(
                                    height: 50,
                                    width: 50,
                                    child:
                                        Image.asset('assets/transparent.gif'),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              // Redirect to Premium Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WritingPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Write your answer",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.green,
                              ),
                            ),
                          ),

                          // Visibility(
                          //   visible: premium_user != true,
                          //   child: AdmobBanner(
                          //       adUnitId: ams.getBannerAdId(),
                          //       adSize: AdmobBannerSize.LARGE_BANNER),
                          // ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),

                                onPressed: () {
                                  // Check if the user is premium
                                  if (!premium_user_google_play) {
                                    // User is premium, show the answer
                                    AdHelper.showRewardedAd(onComplete: () {
                                      // CustomPopupDialog(widget.lesson);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomPopupDialog(
                                              widget.lesson);
                                          // Your custom dialog widget
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
                                              "Upgrade to premium at a very low price to see the answer."),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
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
                                                    builder: (context) =>
                                                        PremiumScreen(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Upgrade",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
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
                                //       return CustomPopupDialog(widget
                                //           .lesson); // Your custom dialog widget
                                //     },
                                //   );
                                // },
                                child: Text(
                                  'Sample Answer',
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
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget dashboard(context) {
  //   CardController controller;
  //   return
  // }
}

var answersResult;
MyAds ads = MyAds();

class CustomPopupDialog extends StatefulWidget {
  final Lesson lesson;
  CustomPopupDialog(this.lesson);

  @override
  State<CustomPopupDialog> createState() => _CustomPopupDialogState();
}

class _CustomPopupDialogState extends State<CustomPopupDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose an option"),
      content: Text("Do you want to continue?"),
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
            // Add your logic for Other button here
            openBookingDetailsSheet(context, widget.lesson);
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

  void openBookingDetailsSheet(BuildContext context, Lesson lesson) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 50, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Text(
                  "Answer Details",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    lesson.answer.replaceAll("_n", "\n"),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Montserrat',
                      letterSpacing: 1.4,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

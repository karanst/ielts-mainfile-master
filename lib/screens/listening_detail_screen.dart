// import 'package:admob_flutter/admob_flutter.dart';
// import 'package:admob_flutter/admob_flutter.dart';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/models/listening.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/premium_screen.dart';
import 'package:ielts/services/admob_service.dart';
import 'package:ielts/widgets/seekBar.dart';
import 'package:just_audio/just_audio.dart';

import '../widgets/adsHelper.dart';
import '../widgets/facebookAds.dart';

final Color backgroundColor = Color(0xFF21BFBD);

class ListeningDetailScreen extends StatefulWidget {
  final Listening listening;
  ListeningDetailScreen({
    // Key key,
    required this.listening,
  });

  @override
  _ListeningDetailScreenState createState() {
    return _ListeningDetailScreenState(listening);
  }
}

class _ListeningDetailScreenState extends State<ListeningDetailScreen>
    with SingleTickerProviderStateMixin {
  final Listening listening;
  _ListeningDetailScreenState(this.listening);

  String s1SubQuestions1Result = '';
  String s1SubQuestions2Result = '';
  String s1SubQuestions3Result = '';
  String answersResult = '';
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

  var adUnit = 'ca-app-pub-2565086294001704/8844512703';

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

  final ams = AdMobService();
  MyAds ads = MyAds();

  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final Duration duration = Duration(milliseconds: 300);

  AudioPlayer _player = AudioPlayer();
  AudioPlayer _player2 = AudioPlayer();
  AudioPlayer _player3 = AudioPlayer();
  AudioPlayer _player4 = AudioPlayer();

  @override
  void initState() {
    initBannerAd();
    loadAd();
    _player = AudioPlayer();
    _player.setUrl(widget.listening.firstSectionAudio).catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });

    // preloading 2nd section audio

    _player2 = AudioPlayer();
    _player2.setUrl(widget.listening.section2Audio).catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });

    // preloading 3rd section audio

    _player3 = AudioPlayer();
    _player3.setUrl(widget.listening.section3Audio).catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });

    // preloading 4th section audio

    _player4 = AudioPlayer();
    _player4.setUrl(widget.listening.section4Audio).catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });

    super.initState();
    // Admob.initialize();
    ams.getAdMobAppId();
  }

  @override
  void dispose() {
    _player.dispose();
    _player2.dispose();
    _player3.dispose();
    _player4.dispose();
    nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

//If the design is based on the size of the iPhone6 ​​(iPhone6 ​​450*1334)
//     ScreenUtil.init(context, width: 414, height: 896);

//If you want to set the font size is scaled according to the system's "font size" assist option
//     ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);

    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: isAdLoaded
            ? SizedBox(
                height: bannerAds.size.height.toDouble(),
                width: bannerAds.size.width.toDouble(),
                child: AdWidget(ad: bannerAds),
              )
            : SizedBox(),
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              }),
          elevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          title: FittedBox(
            child: Text(
              widget.listening.title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            labelStyle: TextStyle(
                fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14)),
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                    child: FittedBox(
                      child: Text(
                        "Section 1",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                    child: FittedBox(
                      child: Text(
                        "Section 2",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                    child: FittedBox(
                      child: Text(
                        "Section 3",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                    child: FittedBox(
                      child: Text(
                        "Section 4",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Material(
            elevation: 8.0,
            animationDuration: duration,
            color: Theme.of(context).primaryColor,
            child: ListView(
              padding:
                  EdgeInsets.only(bottom: 0, top: ScreenUtil().setHeight(20)),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                    // height: MediaQuery.of(context).size.height,

                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    child: ListView(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        ListView(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              bottom: ScreenUtil().setHeight(20)),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.whatToDo
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                            // colorScheme.secondary
                            Divider(),
                            StreamBuilder(
                              stream: _player.playbackEventStream,
                              builder: (context, snapshot) {
                                final fullState = snapshot.data;
                                final state = fullState?.processingState;
                                final buffering = fullState?.bufferedPosition;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (state == ProcessingState.loading ||
                                        buffering == true)
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        width: 45.0,
                                        height: 45.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    else if (state == _player.playing)
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.pause),
                                            color: Colors.deepPurpleAccent,
                                            iconSize: 45.0,
                                            onPressed: _player.pause,
                                          ),
                                          Text(
                                            'Pause',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            iconSize: 45.0,
                                            color: Colors.deepPurpleAccent,
                                            onPressed: () {
                                              _player2.stop();
                                              _player3.stop();
                                              _player4.stop();
                                              _player.play();
                                            },
                                          ),
                                          Text(
                                            'Play',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF1E88E5),
                                                  Color(0xFF64B5F6)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: StreamBuilder(
                                                stream: _player.durationStream,
                                                builder: (context, snapshot) {
                                                  final duration =
                                                      snapshot.data ??
                                                          Duration.zero;
                                                  return StreamBuilder<
                                                      Duration>(
                                                    stream:
                                                        _player.positionStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      var position =
                                                          snapshot.data ??
                                                              Duration.zero;
                                                      if (position > duration) {
                                                        position = duration;
                                                      }
                                                      return SeekBar(
                                                        duration: duration,
                                                        position: position,
                                                        onChangeEnd:
                                                            (newPosition) {
                                                          _player.seek(
                                                              newPosition);
                                                        },
                                                        onChanged:
                                                            (Duration value) {},
                                                        // Customizing SeekBar appearance
                                                        progressBarColor: Colors
                                                            .white, // Color of the progress bar
                                                        bufferedColor: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Color of the buffered portion
                                                        thumbColor: Colors
                                                            .white, // Color of the thumb
                                                        thumbRadius:
                                                            8.0, // Radius of the thumb
                                                        trackHeight:
                                                            4.0, // Height of the track
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (state == ProcessingState.loading ||
                                            buffering == true)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Loading audio...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .blue, // Example color, adjust as needed
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                            height:
                                                16), // Adding space between elements
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.stop),
                                          color: Colors.deepPurpleAccent,
                                          iconSize: 45.0,
                                          onPressed: state ==
                                                      ProcessingState
                                                          .completed ||
                                                  state == ProcessingState.idle
                                              ? null
                                              : _player.stop,
                                        ),
                                        Text(
                                          'Stop',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.intialQuestionNumbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                            // Visibility(
                            //   visible: premium_user != true,
                            //   child: AdmobBanner(
                            //       adUnitId: ams.getBannerAdId(),
                            //       adSize: AdmobBannerSize.FULL_BANNER),
                            // ),

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

                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible:
                                  (widget.listening.firstQuestionImage != '')
                                      ? true
                                      : false,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.listening.firstQuestionImage,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Summary
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.s1SubQuestions1Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.s1SubQuestions1Bool == true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        widget.listening.s1SubQuestions1.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions1Result = widget
                                          .listening.s1SubQuestions1[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions1Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.s1SubQuestions2Bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(8)),
                                child: Text(
                                  widget.listening.s1SubQuestions2Numbers
                                      .replaceAll("_n", "\n"),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(14),
                                      color: Theme.of(context).hintColor),
                                ),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.secondQuestionImageBool ==
                                      true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        widget.listening.secondQuestionImage,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.s1SubQuestions2Bool == true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        widget.listening.s1SubQuestions2.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions2Result = widget
                                          .listening.s1SubQuestions2[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions2Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),

                            // Visibility(
                            //   visible: premium_user != true,
                            //   child: AdmobBanner(
                            //       adUnitId: ams.getBannerAdId(),
                            //       adSize: AdmobBannerSize.BANNER),
                            // ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                // onPressed: () {
                                //   AdHelper.showRewardedAd(onComplete: () {});
                                //   ads.showRewardedAd();
                                //   openAnswersSheet(context, widget.listening);
                                // },

                                onPressed: () {
                                  // Check if the user is premium
                                  if (!premium_user_google_play) {
                                    // User is premium, show the answer
                                    AdHelper.showRewardedAd(onComplete: () {
                                      openAnswersSheet(
                                          context, widget.listening);
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

                                child: Text('Answers',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                      fontFamily: 'Montserrat',
                                    )),
                                color: Colors.deepPurpleAccent,
                                textColor: Colors.white,
                                elevation: 5,
                              ),
                            )
                          ],
                        ),

                        // section 2

                        //

                        //
                      ],
                    )),
              ],
            ),
          ),

          // 2 Section and Tab

          //

          //

          Material(
            elevation: 8.0,
            animationDuration: duration,
            color: Theme.of(context).primaryColor,
            child: ListView(
              padding:
                  EdgeInsets.only(bottom: 0, top: ScreenUtil().setHeight(20)),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                    // height: MediaQuery.of(context).size.height,

                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    child: ListView(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        ListView(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              bottom: ScreenUtil().setHeight(20)),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.s2WhatToDo
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            SizedBox(height: ScreenUtil().setHeight(15)),
                            Divider(),
                            StreamBuilder(
                              stream: _player2.playbackEventStream,
                              builder: (context, snapshot) {
                                final fullState = snapshot.data;
                                final state = fullState?.processingState;
                                final buffering = fullState?.bufferedPosition;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (state == ProcessingState.loading ||
                                        buffering == true)
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(8.0),
                                            width: 45.0,
                                            height: 45.0,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ],
                                      )
                                    else if (state == _player2.playing)
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.pause),
                                            color: Colors.deepPurpleAccent,
                                            iconSize: 45.0,
                                            onPressed: _player2.pause,
                                          ),
                                          Text(
                                            'Pause',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            iconSize: 45.0,
                                            color: Colors.deepPurpleAccent,
                                            onPressed: () {
                                              _player.stop();
                                              _player3.stop();
                                              _player4.stop();
                                              _player2.play();
                                            },
                                          ),
                                          Text(
                                            'Play',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF1E88E5),
                                                  Color(0xFF64B5F6)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: StreamBuilder(
                                                stream: _player2.durationStream,
                                                builder: (context, snapshot) {
                                                  final duration =
                                                      snapshot.data ??
                                                          Duration.zero;
                                                  return StreamBuilder<
                                                      Duration>(
                                                    stream:
                                                        _player2.positionStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      var position =
                                                          snapshot.data ??
                                                              Duration.zero;
                                                      if (position > duration) {
                                                        position = duration;
                                                      }
                                                      return SeekBar(
                                                        duration: duration,
                                                        position: position,
                                                        onChangeEnd:
                                                            (newPosition) {
                                                          _player2.seek(
                                                              newPosition);
                                                        },
                                                        onChanged:
                                                            (Duration value) {},
                                                        // Customizing SeekBar appearance
                                                        progressBarColor: Colors
                                                            .white, // Color of the progress bar
                                                        bufferedColor: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Color of the buffered portion
                                                        thumbColor: Colors
                                                            .white, // Color of the thumb
                                                        thumbRadius:
                                                            8.0, // Radius of the thumb
                                                        trackHeight:
                                                            4.0, // Height of the track
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (state == ProcessingState.loading ||
                                            buffering == true)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Loading audio...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .blue, // Example color, adjust as needed
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                            height:
                                                10), // Adding space between elements
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.stop),
                                          color: Colors.deepPurpleAccent,
                                          iconSize: 45.0,
                                          onPressed: state ==
                                                      ProcessingState
                                                          .completed ||
                                                  state == ProcessingState.idle
                                              ? null
                                              : _player2.stop,
                                        ),
                                        Text(
                                          'Stop',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            Divider(),
                            SizedBox(height: ScreenUtil().setHeight(20)),

                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.s2SubQuestion1Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                            ads.buildNativeAd(),
                            Visibility(
                              visible:
                                  widget.listening.section2Image1Bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.listening.section2Image1,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.s2SubQuestions1Bool == true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        widget.listening.s2SubQuestions1.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions1Result = widget
                                          .listening.s2SubQuestions1[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions1Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),
                            // Summary
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.s2SubQuestion2Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(13),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.section2Image2Bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.listening.section2Image2,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.s2SubQuestions2Bool == true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        widget.listening.s2SubQuestions2.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions2Result = widget
                                          .listening.s2SubQuestions2[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions2Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),

                            // Visibility(
                            //   visible: premium_user != true,
                            //   child: AdmobBanner(
                            //       adUnitId: ams.getBannerAdId(),
                            //       adSize: AdmobBannerSize.BANNER),
                            // ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(10))),
                                // onPressed: () {
                                //   ads.showRewardedAd();
                                //   AdHelper.showRewardedAd(onComplete: () {});
                                //   openSection2AnswersSheet(
                                //       context, widget.listening);
                                // },

                                onPressed: () {
                                  // Check if the user is premium
                                  if (!premium_user_google_play) {
                                    // User is premium, show the answer
                                    AdHelper.showRewardedAd(onComplete: () {
                                      openSection2AnswersSheet(
                                          context, widget.listening);
                                    });
                                  } else {
                                    // User is not premium, prompt to upgrade
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Upgrade to Premium"),
                                          content: Text(
                                              "Upgrade to premium to see the answer."),
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

                                child: Text('Answers',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontFamily: 'Montserrat',
                                    )),
                                color: Colors.deepPurpleAccent,
                                textColor: Colors.white,
                                elevation: 5,
                              ),
                            )
                          ],
                        ),

                        //
                      ],
                    )),
              ],
            ),
          ),

          // section 3 and tab 3

          //

          //

          Material(
            elevation: 8.0,
            animationDuration: duration,
            color: Theme.of(context).primaryColor,
            child: ListView(
              padding: EdgeInsets.only(
                  // left: ScreenUtil().setWidth(10),
                  // right: ScreenUtil().setWidth(10),
                  top: ScreenUtil().setHeight(10)),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                    // height: MediaQuery.of(context).size.height,

                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    child: ListView(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        //

                        ListView(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              bottom: ScreenUtil().setHeight(20)),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.s3WhatToDo
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            // PlayerWidget(url: listening.section3Audio),

                            StreamBuilder(
                              stream: _player3.playbackEventStream,
                              builder: (context, snapshot) {
                                final fullState = snapshot.data;
                                final state = fullState?.processingState;
                                final buffering = fullState?.bufferedPosition;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (state == ProcessingState.loading ||
                                        buffering == true)
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        width: 45.0,
                                        height: 45.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    else if (state == _player3.playing)
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.pause),
                                            color: Colors.deepPurpleAccent,
                                            iconSize: 45.0,
                                            onPressed: _player3.pause,
                                          ),
                                          Text(
                                            'Pause',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            iconSize: 45.0,
                                            color: Colors.deepPurpleAccent,
                                            onPressed: () {
                                              _player.stop();
                                              _player2.stop();
                                              _player4.stop();
                                              _player3.play();
                                            },
                                          ),
                                          Text(
                                            'Play',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF1E88E5),
                                                  Color(0xFF64B5F6)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: StreamBuilder(
                                                stream: _player3.durationStream,
                                                builder: (context, snapshot) {
                                                  final duration =
                                                      snapshot.data ??
                                                          Duration.zero;
                                                  return StreamBuilder<
                                                      Duration>(
                                                    stream:
                                                        _player3.positionStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      var position =
                                                          snapshot.data ??
                                                              Duration.zero;
                                                      if (position > duration) {
                                                        position = duration;
                                                      }
                                                      return SeekBar(
                                                        duration: duration,
                                                        position: position,
                                                        onChangeEnd:
                                                            (newPosition) {
                                                          _player3.seek(
                                                              newPosition);
                                                        },
                                                        onChanged:
                                                            (Duration value) {},
                                                        // Customizing SeekBar appearance
                                                        progressBarColor: Colors
                                                            .white, // Color of the progress bar
                                                        bufferedColor: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Color of the buffered portion
                                                        thumbColor: Colors
                                                            .white, // Color of the thumb
                                                        thumbRadius:
                                                            8.0, // Radius of the thumb
                                                        trackHeight:
                                                            4.0, // Height of the track
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (state == ProcessingState.loading ||
                                            buffering == true)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Loading audio...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .blue, // Example color, adjust as needed
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                            height:
                                                10), // Adding space between elements
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.stop),
                                          color: Colors.deepPurpleAccent,
                                          iconSize: 45.0,
                                          onPressed: state ==
                                                      ProcessingState
                                                          .completed ||
                                                  state == ProcessingState.idle
                                              ? null
                                              : _player3.stop,
                                        ),
                                        Text(
                                          'Stop',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),
                            ads.buildNativeAd(),

                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.section3Question1Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),
                            // Visibility(
                            //   visible: premium_user != true,
                            //   child: Align(
                            //     alignment: Alignment.bottomCenter,
                            //     child: AdmobBanner(
                            //         adUnitId: ams.getBannerAdId(),
                            //         adSize: AdmobBannerSize.FULL_BANNER),
                            //   ),
                            // ),

                            Visibility(
                              visible:
                                  widget.listening.section3Image1Bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.listening.section3Image1,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: widget.listening.section3Question1bool ==
                                  true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget
                                        .listening.section3Question1.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions1Result = widget
                                          .listening.section3Question1[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions1Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),
                            // Summary
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.section3Question2Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(13),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.section3Image2bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.listening.section3Image2,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.section3Questions2bool ==
                                      true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget
                                        .listening.section3Question2.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions2Result = widget
                                          .listening.section3Question2[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions2Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.section3Question3Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(13),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.section3Image3bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.listening.section3Image3,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: widget.listening.section3Question3bool ==
                                  true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget
                                        .listening.section3Question3.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions3Result = widget
                                          .listening.section3Question3[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions3Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),

                            // Visibility(
                            //   visible: premium_user != true,
                            //   child: AdmobBanner(
                            //       adUnitId: ams.getBannerAdId(),
                            //       adSize: AdmobBannerSize.BANNER),
                            // ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setHeight(10))),
                                // onPressed: () {
                                //   AdHelper.showRewardedAd(onComplete: () {
                                //     openSection3AnswersSheet(
                                //         context, widget.listening);
                                //   });
                                //   ads.showRewardedAd();
                                // },
                                onPressed: () {
                                  // Check if the user is premium
                                  if (!premium_user_google_play) {
                                    // User is premium, show the answer
                                    AdHelper.showRewardedAd(onComplete: () {
                                      openSection3AnswersSheet(
                                          context, widget.listening);
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

                                child: Text('Answers',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontFamily: 'Montserrat',
                                    )),
                                color: Colors.deepPurpleAccent,
                                textColor: Colors.white,
                                elevation: 5,
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),

          // section 4

          //

          //

          Material(
            elevation: 8.0,
            animationDuration: duration,
            color: Theme.of(context).primaryColor,
            child: ListView(
              padding: EdgeInsets.only(
                  // left: ScreenUtil().setWidth(10),
                  // right: ScreenUtil().setWidth(10),
                  top: ScreenUtil().setHeight(10)),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                    // height: MediaQuery.of(context).size.height,

                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    child: ListView(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        //

                        ListView(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              bottom: ScreenUtil().setHeight(20)),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.s4WhatToDo
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(14),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            // PlayerWidget(url: listening.section4Audio),

                            StreamBuilder(
                              stream: _player4.playbackEventStream,
                              builder: (context, snapshot) {
                                final fullState = snapshot.data;
                                final state = fullState?.processingState;
                                final buffering = fullState?.bufferedPosition;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (state == ProcessingState.loading ||
                                        buffering == true)
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        width: 45.0,
                                        height: 45.0,
                                        child: CircularProgressIndicator(),
                                      )
                                    else if (state == _player4.playing)
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.pause),
                                            color: Colors.deepPurpleAccent,
                                            iconSize: 45.0,
                                            onPressed: _player4.pause,
                                          ),
                                          Text(
                                            'Pause',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      )
                                    else
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.play_arrow),
                                            iconSize: 45.0,
                                            color: Colors.deepPurpleAccent,
                                            onPressed: () {
                                              _player2.stop();
                                              _player3.stop();
                                              _player.stop();
                                              _player4.play();
                                            },
                                          ),
                                          Text(
                                            'Play',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF1E88E5),
                                                  Color(0xFF64B5F6)
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: StreamBuilder(
                                                stream: _player4.durationStream,
                                                builder: (context, snapshot) {
                                                  final duration =
                                                      snapshot.data ??
                                                          Duration.zero;
                                                  return StreamBuilder<
                                                      Duration>(
                                                    stream:
                                                        _player4.positionStream,
                                                    builder:
                                                        (context, snapshot) {
                                                      var position =
                                                          snapshot.data ??
                                                              Duration.zero;
                                                      if (position > duration) {
                                                        position = duration;
                                                      }
                                                      return SeekBar(
                                                        duration: duration,
                                                        position: position,
                                                        onChangeEnd:
                                                            (newPosition) {
                                                          _player4.seek(
                                                              newPosition);
                                                        },
                                                        onChanged:
                                                            (Duration value) {},
                                                        // Customizing SeekBar appearance
                                                        progressBarColor: Colors
                                                            .white, // Color of the progress bar
                                                        bufferedColor: Colors
                                                            .grey
                                                            .withOpacity(
                                                                0.5), // Color of the buffered portion
                                                        thumbColor: Colors
                                                            .white, // Color of the thumb
                                                        thumbRadius:
                                                            8.0, // Radius of the thumb
                                                        trackHeight:
                                                            4.0, // Height of the track
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (state == ProcessingState.loading ||
                                            buffering == true)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Loading audio...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .blue, // Example color, adjust as needed
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                            height:
                                                10), // Adding space between elements
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.stop),
                                          color: Colors.deepPurpleAccent,
                                          iconSize: 45.0,
                                          onPressed: state ==
                                                      ProcessingState
                                                          .completed ||
                                                  state == ProcessingState.idle
                                              ? null
                                              : _player4.stop,
                                        ),
                                        Text(
                                          'Stop',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: ScreenUtil().setHeight(20)),
                            ads.buildNativeAd(),
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .grey[200], // Set a background color
                                  borderRadius: BorderRadius.circular(
                                      10), // Add rounded corners
                                ),
                                padding: EdgeInsets.all(ScreenUtil().setHeight(
                                    16)), // Increase padding for better readability
                                child: Text(
                                  widget.listening.section4Question1Numbers
                                      .replaceAll("_n", "\n"),
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(
                                        14), // Slightly increase font size
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.section4Image1Bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.listening.section4Image1,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.listening.section4Question1Bool ==
                                  true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget
                                        .listening.section4Question1.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions1Result = widget
                                          .listening.section4Question1[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions1Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),
                            // Summary
                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.section4Question2Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(13),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            Visibility(
                              visible:
                                  widget.listening.section4Image2Bool == true,
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: FittedBox(
                                  child: CachedNetworkImage(
                                    imageUrl: widget.listening.section4Image2,
                                    placeholder: (context, url) => SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                          Image.asset('assets/transparent.gif'),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Column(
                                      children: <Widget>[
                                        Icon(Icons.error),
                                        Text(
                                            'Please check your internet connection')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                              visible: widget.listening.section4Question2Bool ==
                                  true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget
                                        .listening.section4Question2.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions2Result = widget
                                          .listening.section4Question2[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions2Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),

                            Padding(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setHeight(8)),
                              child: Text(
                                widget.listening.section4Question3Numbers
                                    .replaceAll("_n", "\n"),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(13),
                                    color: Theme.of(context).hintColor),
                              ),
                            ),

                            Visibility(
                              visible: widget.listening.section4Question3Bool ==
                                  true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(10)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget
                                        .listening.section4Question3.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      s1SubQuestions3Result = widget
                                          .listening.section4Question3[index];
                                      return ListTile(
                                        title: Text(
                                          s1SubQuestions3Result.replaceAll(
                                              "_n", "\n"),
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontFamily: 'Montserrat',
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  )),
                            ),

                            // Visibility(
                            //   visible: premium_user != true,
                            //   child: AdmobBanner(
                            //       adUnitId: ams.getBannerAdId(),
                            //       adSize: AdmobBannerSize.BANNER),
                            // ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setHeight(10))),
                                // onPressed: () {
                                //   ads.showRewardedAd();
                                //   AdHelper.showRewardedAd(onComplete: () {});
                                //   openSection4AnswersSheet(
                                //       context, widget.listening);
                                // },
                                onPressed: () {
                                  // Check if the user is premium
                                  if (!premium_user_google_play) {
                                    // User is premium, show the answer
                                    // AdHelper.showRewardedAd(onComplete: () {
                                    openSection4AnswersSheet(
                                        context, widget.listening);
                                    // });
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

                                child: Text('Answers',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      fontFamily: 'Montserrat',
                                    )),
                                color: Colors.deepPurpleAccent,
                                textColor: Colors.white,
                                elevation: 5,
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void openAnswersSheet(BuildContext context, Listening listening) {
    showModalBottomSheet<Widget>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Listening Answers",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listening.answers.length,
                itemBuilder: (BuildContext context, int index) {
                  String answersResult = listening.answers[index];
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

  void openSection2AnswersSheet(BuildContext context, Listening listening) {
    showModalBottomSheet<Widget>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Listening Section 2 Answers",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listening.section2Answers.length,
                itemBuilder: (BuildContext context, int index) {
                  String answersResult = listening.section2Answers[index];
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

  // section 3 answer sheet
  void openSection3AnswersSheet(BuildContext context, Listening listening) {
    showModalBottomSheet<Widget>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) => Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Listening Section 3 Answers",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listening.section3Answers.length,
                itemBuilder: (BuildContext context, int index) {
                  String answersResult = listening.section3Answers[index];
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

  // SECTION 4 ANSWER SHEET

  void openSection4AnswersSheet(BuildContext context, Listening listening) {
    showModalBottomSheet<Widget>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Listening Section 4 Answers",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listening.section4Answers.length,
                itemBuilder: (BuildContext context, int index) {
                  String answersResult = listening.section4Answers[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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

  Widget bullet() => Container(
      height: ScreenUtil().setHeight(20),
      width: ScreenUtil().setWidth(20),
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ));
}

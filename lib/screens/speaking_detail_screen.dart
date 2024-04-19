// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ielts/SpeakingPage.dart';
import 'package:ielts/models/speaking.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/services/admob_service.dart';

import '../widgets/facebookAds.dart';

class SpeakingDetailScreen extends StatefulWidget {
  final Speaking speaking;
  SpeakingDetailScreen({
    // Key key,
    required this.speaking,
  });

  @override
  _SpeakingDetailScreenState createState() => _SpeakingDetailScreenState();
}

enum TtsState { playing, stopped }

class _SpeakingDetailScreenState extends State<SpeakingDetailScreen>
    with SingleTickerProviderStateMixin {
  FlutterTts flutterTts = FlutterTts();

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  TtsState ttsState = TtsState.stopped;
  MyAds ads = MyAds();
  final ams = AdMobService();

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  // final Speaking speaking;
  // _SpeakingDetailScreenState(this.speaking);

  bool isCollapsed = true;
  String? resultant;
  String? vocabResult;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    initTts();
    // Admob.initialize();
    ams.getAdMobAppId();
  }

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (widget.speaking.answer != null) {
      if (widget.speaking.answer.isNotEmpty) {
        var result = await flutterTts.speak(widget.speaking.answer);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 100, // Adjust the height according to your banner ad's size
          alignment: Alignment.center,
          child: ads.buildBannerAd(), // Display the banner ad
        ),
      ),
      appBar: AppBar(
        title: Text(widget.speaking.title.replaceAll("_n", "\n"),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(18),
            )),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          // MenuPage(),
          Material(
            animationDuration: duration,
            // borderRadius: BorderRadius.all(Radius.circular(40)),
            elevation: 8,
            color: Theme.of(context).primaryColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
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
                            topLeft: Radius.circular(
                          ScreenUtil().setWidth(75),
                        )),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                            ),
                            physics: ScrollPhysics(),
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF21BFBD),
                                      Color(0xFF1FCCB1)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(14)),
                                child: Center(
                                  child: Text(
                                    'Things to Speak',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(20),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                    ScreenUtil().setHeight(20),
                                  )),
                                  elevation: 5,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(10),
                                        right: ScreenUtil().setWidth(45),
                                        top: ScreenUtil().setHeight(10),
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: widget
                                            .speaking.thingsToSpeak.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          resultant = widget
                                              .speaking.thingsToSpeak[index];

                                          return ListTile(
                                            leading: Container(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                                width:
                                                    ScreenUtil().setWidth(10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  shape: BoxShape.circle,
                                                )),
                                            title: Text(
                                              resultant!.replaceAll('_n', '\n'),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(14),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                ),
                              ),
                              ads.buildNativeAd(),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Speak and see Confidence Level',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            16), // Space between title and bottom section
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 32),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => spaceToText()),
                                          );
                                        },
                                        icon: Icon(
                                            Icons.mic), // Icon for the button
                                        label: Text(
                                            'Start'), // Text for the button
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF21BFBD),
                                      Color(0xFF1FCCB1)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setHeight(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Listen to sample answer',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(20),
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              _btnSection(),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),

                              // Visibility(
                              //   visible: premium_user != true,
                              //   child: AdmobBanner(
                              //       adUnitId: ams.getBannerAdId(),
                              //       adSize: AdmobBannerSize.LARGE_BANNER),
                              // ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF21BFBD),
                                      Color(0xFF1FCCB1)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setHeight(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sample answer',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(20),
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(15)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.speaking.answer.replaceAll("_n", "\n"),
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(16),
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF21BFBD),
                                      Color(0xFF1FCCB1)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    ScreenUtil().setHeight(8),
                                  ),
                                  child: FittedBox(
                                    child: Center(
                                      child: Text(
                                        'Important Keywords for vocabulary',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setSp(20),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                  top: ScreenUtil().setHeight(10),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget.speaking.vocabulary.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    vocabResult =
                                        widget.speaking.vocabulary[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            height: ScreenUtil().setHeight(20),
                                            width: ScreenUtil().setWidth(20),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              vocabResult!
                                                  .replaceAll("_n", "\n"),
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(16),
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87,
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
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget dashboard(context) {
  //   CardController controller;
  //   return
  // }

  Widget _btnSection() => Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _speak,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 8,
              ),
              icon: Icon(Icons.play_arrow),
              label: Text(
                'PLAY',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _stop,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 8,
              ),
              icon: Icon(Icons.stop),
              label: Text(
                'STOP',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              iconSize: ScreenUtil().setHeight(40),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              child: Text(label,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary)))
        ]);
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/models/lesson.dart';
import 'package:ielts/widgets/adsHelper.dart';

class WritingPage extends StatefulWidget {
  const WritingPage();
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  TextEditingController _answerController = TextEditingController();
  String _question = "Write Your answer.";
  String _submittedAnswer = "";
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

  void initState() {
    super.initState();
    // Admob.initialize();

    loadAd();
  }

  void dispose() {
    nativeAd?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Writing Section',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.blueGrey, // Example color
        elevation: 0, // Set elevation to 0 to remove shadow
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display the question
              Text(
                _question,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),

              // Text input field for the answer with syntax highlighting
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: _answerController,
                  maxLines: null,
                  style: TextStyle(fontStyle: FontStyle.italic),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Write your answer here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Submit button
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  AdHelper.showInterstitialAd(onComplete: () {
                    setState(() {
                      _submittedAnswer = _answerController.text;

                      // Clear the text input field
                      _answerController.clear();
                    });
                  });
                  // Here you can trigger further analysis and feedback generation
                  // For now, let's just print the submitted answer
                },
                child: Text('Submit'),
              ),

              SizedBox(height: 20.0),
              // Display the submitted answer
              Text(
                'Submitted Answer:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_submittedAnswer),
              SizedBox(height: 20.0),

              // Clear submitted text button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _submittedAnswer = "";
                  });
                },
                child: Text('Clear Submitted Text'),
              ),

              // Display feedback (initially with a placeholder message)
              // Text(
              //   'Sample answer:',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // ElevatedButton(
              //   onPressed: () {},
              //   child: Text(_feedback),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

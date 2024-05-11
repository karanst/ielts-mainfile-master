// import 'package:admob_flutter/admob_flutter.dart';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_grouped_buttons/flut_grouped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:ielts/models/lesson.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/writing_detail_screen.dart';
import 'package:ielts/services/admob_service.dart';
import 'package:ielts/viewModels/writingCrudModel.dart';
import 'package:ielts/widgets/lessonCard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/adsHelper.dart';

final Color backgroundColor = Color(0xFF21BFBD);
bool premium_user_google_play = false;

class WritingScreen extends StatefulWidget {
  // WritingScreen({Key key}) : super(key: key);

  @override
  _WritingScreenState createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen>
    with SingleTickerProviderStateMixin {
  late List<Lesson> lessons;
  List? writing;
  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final ams = AdMobService();
  late BannerAd bannerAds;
  bool isAdLoaded = false;
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

  List<String> checkedWritingItems = [];
  final Duration duration = const Duration(milliseconds: 300);

  void _getcheckedWritingItems() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('checkedWritingItems')) {
      checkedWritingItems = prefs.getStringList('checkedWritingItems')!;
    } else {
      prefs.setStringList('checkedWritingItems', checkedWritingItems);
    }
  }

  @override
  void initState() {
    _getcheckedWritingItems();
    super.initState();
    // Admob.initialize();
    ams.getAdMobAppId();
    initBannerAd();
    // lessons = getWritingData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _adController = NativeAdController();
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
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    return Scaffold(
      bottomNavigationBar: isAdLoaded
          ? SizedBox(
              height: bannerAds.size.height.toDouble(),
              width: bannerAds.size.width.toDouble(),
              child: AdWidget(ad: bannerAds),
            )
          : SizedBox(),

      // bottomNavigationBar:
      //     _adController.ad != null && _adController.adLoaded.isTrue
      //         ? SizedBox(
      //             height: 80,
      //             child: AdWidget(ad: _adController.ad!),
      //           )
      //         : null,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Writing Exercises',
          style: TextStyle(
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
            }),
        bottomOpacity: 0.0,
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.push(
      //           context, MaterialPageRoute(builder: (context) => AddWriting()));
      //     }),
      body: dashboard(context),
    );
  }

  Widget dashboard(context) {
    final productProvider = Provider.of<CrudModel>(context);
    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),
      elevation: 8,
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(20)),
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
              child: Container(
                // height: screenHeight,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('lesson')
                        .snapshots(),
                    // stream: productProvider.fetchLessonsAsStream(),
                    builder: (context, snapshot) {
                      // if (snapshot.hasData) {
                      //   lessons = snapshot.data!.docs
                      //       .map((doc) =>
                      //           Lesson.fromMap(doc.data as Map, doc.id))
                      //       .toList();
                      //
                      //   return ListView.builder(
                      //     scrollDirection: Axis.vertical,
                      //     padding: EdgeInsets.only(
                      //         top: ScreenUtil().setHeight(70),
                      //         bottom: ScreenUtil().setHeight(50)),
                      //     shrinkWrap: true,
                      //     physics: ScrollPhysics(),
                      //     itemCount: lessons?.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       _getcheckedWritingItems();
                      //       print('title new${lessons}');
                      //       return makeCard(lessons[index]);
                      //     },
                      //   );
                      // }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error fetching data'));
                      }

                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data!.docs.length > 0) {
                        print('listener it listening ');
                        lessons = snapshot.data!.docs
                            .map((doc) => Lesson.fromMap(
                                doc.data() as Map<String, dynamic>, doc.id))
                            .toList();
                        print('data ${lessons?[0].title}');
                        print('data length: ${lessons?.length}');
                        return Container(
                          height: screenHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(70),
                              bottom: ScreenUtil().setHeight(50),
                            ),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: lessons?.length,
                            itemBuilder: (BuildContext context, int index) {
                              // return
                              // Center(child: Text('data okay ha '));
                              // print('data okay ha ${listening?[0].title}');
                              return makeCard(lessons![index]);
                            },
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container(
                            height: screenHeight,
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.redAccent)));
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isChecked = false;
  String label = '';
  Widget makeCard(Lesson lesson) {
    print('title new${writing}');
    return LessonCard(
      title: lesson.title,
      indicatorValue: lesson.indicatorValue,
      level: lesson.level,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WritingDetailScreen(lesson: lesson)));
      },
      trailing: SizedBox(
        height: 100,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.all(20),
          child: FlutGroupedButtons(
              isRadio: true,
              idKey: 'id',
              valueKey: 'level',
              data: [
                {"id": writing?.length, "level": writing?.length},
              ],
              checkColor: Colors.white,
              activeColor: Colors.black,
              labelStyle: TextStyle(fontSize: 0),
              // onSelected: (List<String> checked) {
              //   print("${checked.toString()}");
              // },
              onChanged: (index) async {
                print(label);
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool(label, isChecked);
                print(prefs.getBool(label) ?? 0);

                setState(() {
                  isChecked = prefs.getBool(label)!;

                  if (checkedWritingItems.contains(label)) {
                    checkedWritingItems.remove(label);
                  } else {
                    checkedWritingItems.add(label);
                  }
                  prefs.setStringList(
                      'checkedWritingItems', checkedWritingItems);
                  print(checkedWritingItems);
                });
              }),
        ),
      ),
    );
  }
}

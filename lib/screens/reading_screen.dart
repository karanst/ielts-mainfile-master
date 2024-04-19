// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_grouped_buttons/flut_grouped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/models/listselection.dart';
import 'package:ielts/models/matchendings.dart';
import 'package:ielts/models/matchparagraphs.dart';
import 'package:ielts/models/mcqs.dart';
// import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:ielts/models/reading.dart';
import 'package:ielts/models/shortasnwers.dart';
import 'package:ielts/models/summarycompletion.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/reading_detail_screen.dart';
import 'package:ielts/screens/sentencecompletionscreen.dart';
import 'package:ielts/screens/shortasnwer_detailscreen.dart';
import 'package:ielts/services/admob_service.dart';
// import 'package:ielts/services/admob_service.dart';
import 'package:ielts/viewModels/readingCrudModel.dart';
import 'package:ielts/widgets/lessonCard.dart';
import 'package:native_ads_flutter/native_ads.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/headingcompletion.dart';
import '../models/sentencecompletion.dart';
import '../models/trueorfalse.dart';
import '../widgets/adsHelper.dart';
import 'headingcompletiondetails.dart';
import 'listdetail_screen.dart';
import 'matchending_detailscreen.dart';
import 'matchingparagraphdetailscreen.dart';
import 'mcqdetails_screen.dart';
import 'summarycompletiondetail.dart';

class ReadingScreen extends StatefulWidget {
  // ReadingScreen({Key key}) : super(key: key);

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen>
    with TickerProviderStateMixin {
  List? reading;
  late List<HeadingCompletion> headingcompletion;
  List? trueOrFalse;
  List? headings;
  List? summary;
  List? matchparagraph;
  List? paragraph;
  List? mcqs;
  List? listSelection;
  List? titleSelection;
  List? categorization;
  List? matchingEndings;
  List? saqs;
  List? sentencecompletion;

  final ams = AdMobService();

  bool isCollapsed = true;
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController? _controller;
  TabController? _tabController;

  List<String> checkedReadingItems = [];

  void _getcheckedReadingItems() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('checkedReadingItems')) {
      checkedReadingItems = prefs.getStringList('checkedReadingItems')!;
    } else {
      prefs.setStringList('checkedReadingItems', checkedReadingItems);
    }
  }

  final nativeAdsController = NativeAdmobController();
  @override
  void initState() {
    _tabController = TabController(length: 9, vsync: this);
    _getcheckedReadingItems();

    super.initState();
    // Admob.initialize();
    ams.getAdMobAppId();
    _controller = AnimationController(vsync: this, duration: duration);

    // readings = getReadingData();
    // trueOrFalse = getTrueFalseData();
    // headings = getHeadingData();
    // summary = getSummaryCompletionData();
    // paragraph = getParagraphMatching();
    // mcqs = getMCQs();
    // listSelection = getListSelectionData();
    // titleSelection = getTitleSelectionData();
    // categorization = getCategorizationData();
    // matchingEndings = getMatchingEndingsData();
    // saqs = getSAQs();
  }

  final _adController = NativeAdController();

  @override
  void dispose() {
    _controller?.dispose();
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
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    return Scaffold(
      bottomNavigationBar:
          _adController.ad != null && _adController.adLoaded.isTrue
              ? SizedBox(
                  height: 80,
                  child: AdWidget(ad: _adController.ad!),
                )
              : null,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Reading Exercises',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          labelColor: Colors.white,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(14)),
          unselectedLabelColor: Colors.white,
          tabs: [
            Tab(
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Text(
                  "True/ False",
                  textAlign: TextAlign.center,
                ),
              )),
            ),
            Tab(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                  child: Text(
                    "Sentence \n Completion",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                  child: Text(
                    "Heading \n Completion",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Text(
                  "Summary \n Completion",
                  textAlign: TextAlign.center,
                ),
              )),
            ),
            Tab(
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Text(
                  "Matching \n Paragraphs",
                  textAlign: TextAlign.center,
                ),
              )),
            ),
            Tab(
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Text(
                  "MCQs",
                ),
              )),
            ),
            Tab(
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Text(
                  "List \n Selection",
                  textAlign: TextAlign.center,
                ),
              )),
            ),
            // Tab(
            //   child: FittedBox(
            //       child: Padding(
            //     padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
            //     child: Text(
            //       "Categorization",
            //       textAlign: TextAlign.center,
            //     ),
            //   )),
            // ),
            Tab(
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Text(
                  "Matching \n Endings",
                  textAlign: TextAlign.center,
                ),
              )),
            ),
            Tab(
              child: FittedBox(
                  child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                child: Text(
                  "Short \n Answers",
                  textAlign: TextAlign.center,
                ),
              )),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          trueFalseDashBoard(context),
          sentenceDashboard(context),
          headingDashboard(context),
          summaryDashboard(context),
          paragraphDashboard(context),
          mcqDashboard(context),
          selectionDashboard(context),
          // categoryDashboard(context),
          endingsDashboard(context),
          saqDashboard(context),
        ],
        controller: _tabController,
      ),
    );
  }

  Widget sentenceDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);
    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,

      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: ScreenUtil().setHeight(20)),
            Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setWidth(45)),
                // ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('sentencecompletion')
                      .snapshots(),
                  // stream: productProvider.fetchSentenceCollectionAsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      sentencecompletion = snapshot.data?.docs
                          .map((doc) => SentenceCompletion?.fromMap(
                              doc.data() as Map<String, dynamic>, doc.id))
                          .toList();
                      // if (snapshot.hasData) {
                      //   reading = snapshot.data?.docs
                      //       .map((doc) =>
                      //           Reading.fromMap(doc.data as Map, doc.id))
                      //       .toList();
                      print(snapshot.error);
                      print('okay finekikglk');

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(40),
                            bottom: ScreenUtil().setHeight(50)),
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: sentencecompletion?.length,
                        itemBuilder: (BuildContext context, int index) {
                          print('acha');
                          _getcheckedReadingItems();
                          return makeCardsen(sentencecompletion?[index]);
                        },
                      );
                    } else {
                      return Container(
                          height: screenHeight,
                          child: Center(child: CircularProgressIndicator()));
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget trueFalseDashBoard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                // ),
              ),
              child: Container(
                // height: screenHeight,
                child: Consumer<ReadingCrudModel>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('trueorfalse')
                          .snapshots(),
                      // stream: productProvider?.fetchTrueOrFalseAsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          trueOrFalse = snapshot.data?.docs
                              .map((doc) => TrueOrFalse.fromMap(
                                  doc.data() as Map<String, dynamic>, doc.id))
                              .toList();
                          print('data ${trueOrFalse}');
                          productProvider?.fetchTrueOrFalseAsStream().listen(
                              (data) {
                            print('Stream emitted data: $data');
                          }, onError: (error) {
                            print('Error in stream: $error');
                          });

                          print('okay fine');
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(40),
                              bottom: ScreenUtil().setHeight(10),
                            ),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: trueOrFalse?.length,
                            itemBuilder: (BuildContext context, int index) {
                              print('listening');
                              _getcheckedReadingItems();
                              print(
                                  'reading it listening ${trueOrFalse?[index].question}');
                              // return Text('${trueOrFalse?[index].question}');
                              return makeCard(trueOrFalse?[index]);
                            },
                          );
                        } else {
                          return Container(
                            height: screenHeight,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            /* Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                // ),
              ),
              child: Container(
                // height: screenHeight,
                child: Consumer<ReadingCrudModel>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('trueorfalse')
                          .snapshots(),
                      // stream: productProvider?.fetchTrueOrFalseAsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          trueOrFalse = snapshot.data?.docs
                              .map((doc) => TrueOrFalse.fromMap(
                                  doc.data() as Map<String, dynamic>, doc.id))
                              .toList();
                          print('data ${trueOrFalse}');
                          productProvider?.fetchTrueOrFalseAsStream().listen(
                              (data) {
                            print('Stream emitted data: $data');
                          }, onError: (error) {
                            print('Error in stream: $error');
                          });

                          print('okay fine');
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(5),
                              bottom: ScreenUtil().setHeight(5),
                            ),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: trueOrFalse?.length,
                            itemBuilder: (BuildContext context, int index) {
                              print('listening');
                              _getcheckedReadingItems();
                              print(
                                  'reading it listening ${trueOrFalse?[index].question}');
                              // return Text('${trueOrFalse?[index].question}');
                              return makeCard(trueOrFalse?[index]);
                            },
                          );
                        } else {
                          return Container(
                            height: screenHeight,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                // ),
              ),
              child: Container(
                // height: screenHeight,
                child: Consumer<ReadingCrudModel>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<QuerySnapshot>(
                      // stream: FirebaseFirestore.instance
                      //     .collection('trueorfalse')
                      //     .snapshots(),
                      stream: productProvider?.fetchTrueOrFalseAsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          trueOrFalse = snapshot.data?.docs
                              .map((doc) => TrueOrFalse.fromMap(
                                  doc.data() as Map<String, dynamic>, doc.id))
                              .toList();
                          print('data ${trueOrFalse}');
                          productProvider?.fetchTrueOrFalseAsStream().listen(
                              (data) {
                            print('Stream emitted data: $data');
                          }, onError: (error) {
                            print('Error in stream: $error');
                          });

                          print('okay fine');
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(5),
                              bottom: ScreenUtil().setHeight(5),
                            ),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: trueOrFalse?.length,
                            itemBuilder: (BuildContext context, int index) {
                              print('listening');
                              _getcheckedReadingItems();
                              print(
                                  'reading it listening ${trueOrFalse?[index].question}');
                              // return Text('${trueOrFalse?[index].question}');
                              return makeCard(trueOrFalse?[index]);
                            },
                          );
                        } else {
                          return Container(
                            height: screenHeight,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                // ),
              ),
              child: Container(
                // height: screenHeight,
                child: Consumer<ReadingCrudModel>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('trueorfalse')
                          .snapshots(),
                      // stream: productProvider?.fetchTrueOrFalseAsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          trueOrFalse = snapshot.data?.docs
                              .map((doc) => TrueOrFalse.fromMap(
                                  doc.data() as Map<String, dynamic>, doc.id))
                              .toList();
                          print('data ${trueOrFalse}');
                          productProvider?.fetchTrueOrFalseAsStream().listen(
                              (data) {
                            print('Stream emitted data: $data');
                          }, onError: (error) {
                            print('Error in stream: $error');
                          });

                          print('okay fine');
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(5),
                              bottom: ScreenUtil().setHeight(5),
                            ),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: trueOrFalse?.length,
                            itemBuilder: (BuildContext context, int index) {
                              print('listening');
                              _getcheckedReadingItems();
                              print(
                                  'reading it listening ${trueOrFalse?[index].question}');
                              // return Text('${trueOrFalse?[index].question}');
                              return makeCard(trueOrFalse?[index]);
                            },
                          );
                        } else {
                          return Container(
                            height: screenHeight,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                // ),
              ),
              child: Container(
                // height: screenHeight,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('trueorfalse')
                      .snapshots(),
                  // stream: productProvider?.fetchTrueOrFalseAsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      trueOrFalse = snapshot.data?.docs
                          .map((doc) => TrueOrFalse.fromMap(
                              doc.data() as Map<String, dynamic>, doc.id))
                          .toList();
                      print('data ${trueOrFalse}');
                      productProvider?.fetchTrueOrFalseAsStream().listen(
                          (data) {
                        print('Stream emitted data: $data');
                      }, onError: (error) {
                        print('Error in stream: $error');
                      });

                      print('okay fine');
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(5),
                          bottom: ScreenUtil().setHeight(5),
                        ),
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: trueOrFalse?.length,
                        itemBuilder: (BuildContext context, int index) {
                          print('listening');
                          _getcheckedReadingItems();
                          print('reading it listening ${trueOrFalse?[index]}');
                          // return Text('${trueOrFalse?[index].question}');
                          return makeCard(trueOrFalse?[index]);
                        },
                      );
                    } else {
                      return Container(
                        height: screenHeight,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            ),
*/
            // AdHelper.loadNativeAd(adController: (){
            //
            // })
          ],
        ),
      ),
    );
  }

  Widget headingDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                // ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('headingcompletion')
                    .snapshots(),
                // stream: productProvider.fetchTrueOrFalseAsStream(),

                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    headingcompletion = snapshot.data!.docs
                        .map((doc) => HeadingCompletion.fromMap(
                            doc.data() as Map<String, dynamic>, doc.id))
                        .toList();

                    print('data ${trueOrFalse}');
                    print('okay fine');

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(40),
                        bottom: ScreenUtil().setHeight(70),
                      ),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: headingcompletion?.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(' listening');
                        _getcheckedReadingItems();
                        print('reading it listening');
                        return makeCardhed(headingcompletion![index]);
                      },
                    );
                  } else {
                    return Container(
                      height: screenHeight,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              // StreamBuilder(
              //     stream: productProvider.fetchHeadingCompletionAsStream(),
              //     builder:
              //         (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.hasData) {
              //         headings = snapshot.data?.docs
              //             .map((doc) =>
              //                 Reading.fromMap(doc.data as Map, doc.id))
              //             .toList();
              //
              //         return ListView.builder(
              //           scrollDirection: Axis.vertical,
              //           padding: EdgeInsets.only(
              //               top: ScreenUtil().setHeight(40),
              //               bottom: ScreenUtil().setHeight(70)),
              //           shrinkWrap: true,
              //           physics: ScrollPhysics(),
              //           itemCount: headings?.length,
              //           itemBuilder: (BuildContext context, int index) {
              //             _getcheckedReadingItems();
              //             return makeCard(headings?[index]);
              //           },
              //         );
              //       } else {
              //         return Container(
              //             height: screenHeight,
              //             child:
              //                 Center(child: CircularProgressIndicator()));
              //       }
              //     }),
            )
          ],
        ),
      ),
    );
  }

  Widget summaryDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                // ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('summarycompletion')
                      // .doc('xwmDpCrQRpUNzXJWupGA'),
                      .snapshots(),
                  // stream: productProvider.fetchTrueOrFalseAsStream(),

                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      summary = snapshot.data!.docs
                          .map((doc) => SummaryCompletion.fromMap(
                              doc.data() as Map<String, dynamic>, doc.id))
                          .toList();
                      // stream: productProvider.fetchSummaryCompletionAsStream(),
                      // builder:
                      //     (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      //   if (snapshot.hasData) {
                      //     summary = snapshot.data?.docs
                      //         .map((doc) =>
                      //             Reading.fromMap(doc.data as Map, doc.id))
                      //         .toList();
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(40),
                            bottom: ScreenUtil().setHeight(70)),
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: summary?.length,
                        itemBuilder: (BuildContext context, int index) {
                          _getcheckedReadingItems();
                          return makeCardsum(summary?[index]);
                        },
                      );
                    } else {
                      return Container(
                          height: screenHeight,
                          child: Center(child: CircularProgressIndicator()));
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget paragraphDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                  // ),
                ),
                child: Container(
                  // height: screenHeight,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('matchingparagraphs')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasData) {
                        matchparagraph = snapshot.data!.docs
                            .map((doc) =>
                                MatchingParagraphs.fromMap(doc.data(), doc.id))
                            .toList();
                        print('okay hai bhai');
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(40),
                            bottom: ScreenUtil().setHeight(70),
                          ),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: matchparagraph?.length,
                          itemBuilder: (BuildContext context, int index) {
                            _getcheckedReadingItems();
                            return makeCardpara(matchparagraph?[index]);
                          },
                        );
                      } else {
                        return Container(
                          height: screenHeight,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mcqDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                  // ),
                ),
                child: Container(
                  // height: screenHeight,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('mcqs')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasData) {
                        mcqs = snapshot.data?.docs
                            .map((doc) => MCQs.fromMap(
                                doc.data() as Map<String, dynamic>,
                                doc.id)) // Change here
                            .toList();
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(40),
                            bottom: ScreenUtil().setHeight(70),
                          ),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: mcqs?.length,
                          itemBuilder: (BuildContext context, int index) {
                            _getcheckedReadingItems();
                            print(
                                'MCQs it listening '); // Update this log message
                            return makeCardmcq(mcqs?[index]);
                          },
                        );
                      } else {
                        return Container(
                          height: screenHeight,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectionDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                  // ),
                ),
                child: Container(
                  // height: screenHeight,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('listselection')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasData) {
                          listSelection = snapshot.data?.docs
                              .map((doc) => ListSelection.fromMap(
                                  doc.data() as Map<String, dynamic>,
                                  doc.id)) // Change here
                              .toList();

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(40),
                                bottom: ScreenUtil().setHeight(70)),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: listSelection?.length,
                            itemBuilder: (BuildContext context, int index) {
                              _getcheckedReadingItems();
                              return makeCardList(listSelection?[index]);
                            },
                          );
                        } else {
                          return Container(
                              height: screenHeight,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget titleDashboard(context) {
  //   final productProvider = Provider.of<ReadingCrudModel>(context);

  //   return Material(
  //     animationDuration: duration,
  //     // borderRadius: BorderRadius.all(Radius.circular(40)),
  //
  //     color: Theme.of(context).primaryColor,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.vertical,
  //       physics: ClampingScrollPhysics(),
  //       child: Container(
  //         padding: EdgeInsets.all(ScreenUtil().setHeight(48)),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             SizedBox(height: ScreenUtil().setHeight(40),),
  //             Container(
  //               // height: MediaQuery.of(context).size.height,
  //               decoration: BoxDecoration(
  //                 boxShadow: [
  //                   BoxShadow(
  //                       color: Theme.of(context).secondaryHeaderColor,
  //                       blurRadius: 10)
  //                 ],
  //                 color: Theme.of(context).canvasColor,
  //                 borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(75.0),
  //                     topRight: Radius.circular(75.0)),
  //               ),
  //               child: Container(
  //                 // height: screenHeight,
  //                 child: StreamBuilder(
  //                     stream: productProvider.fetchTitleSelectionAsStream(),
  //                     builder:
  //                         (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //                       if (snapshot.hasData) {
  //                         titleSelection = snapshot.data.documents
  //                             .map((doc) =>
  //                                 Reading.fromMap(doc.data, doc.documentID))
  //                             .toList();
  //                         return ListView.builder(
  //                           scrollDirection: Axis.vertical,
  //                           padding: EdgeInsets.only(top: ScreenUtil().setHeight(40), bottom: ScreenUtil().setHeight(70)),
  //                           shrinkWrap: true,
  //                           physics: ScrollPhysics(),
  //                           itemCount: titleSelection.length,
  //                           itemBuilder: (BuildContext context, int index) {
  //                             _getcheckedReadingItems();
  //                             return makeCard(titleSelection[index]);
  //                           },
  //                         );
  //                       } else {
  //                         return CircularProgressIndicator();
  //                       }
  //                     }),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget categoryDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                  // ),
                ),
                child: Container(
                  // height: screenHeight,
                  child: StreamBuilder(
                      stream: productProvider.fetchCategorizationAsStream(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          categorization = snapshot.data?.docs
                              .map((doc) =>
                                  Reading.fromMap(doc.data as Map, doc.id))
                              .toList();
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(40),
                                bottom: ScreenUtil().setHeight(70)),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: categorization?.length,
                            itemBuilder: (BuildContext context, int index) {
                              _getcheckedReadingItems();
                              return Container(
                                  height: screenHeight,
                                  child: Center(
                                      child: CircularProgressIndicator()));
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget endingsDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          // padding: EdgeInsets.all(ScreenUtil().setHeight(48)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                  // ),
                ),
                child: Container(
                  // height: screenHeight,
                  child: StreamBuilder(
                      // stream: productProvider.fetchEndingSelectionAsStream(),
                      stream: FirebaseFirestore.instance
                          .collection('matchendings')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasData) {
                          matchingEndings = snapshot.data?.docs
                              .map((doc) => MatchEndings.fromMap(
                                  doc.data() as Map<String, dynamic>,
                                  doc.id)) // Change here
                              .toList();

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(40),
                                bottom: ScreenUtil().setHeight(70)),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: matchingEndings?.length,
                            itemBuilder: (BuildContext context, int index) {
                              _getcheckedReadingItems();
                              return makeCardEnd(matchingEndings?[index]);
                            },
                          );
                        } else {
                          return Container(
                              height: screenHeight,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget saqDashboard(context) {
    final productProvider = Provider.of<ReadingCrudModel>(context);

    return Material(
      animationDuration: duration,
      // borderRadius: BorderRadius.all(Radius.circular(40)),

      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          // padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(ScreenUtil().setHeight(45)),
                  // ),
                ),
                child: Container(
                  // height: screenHeight,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('shortanswers')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasData) {
                          saqs = snapshot.data?.docs
                              .map((doc) => ShortAnswer.fromMap(
                                  doc.data() as Map<String, dynamic>,
                                  doc.id)) // Change here
                              .toList();
                          // stream: productProvider.fetchSAQsAsStream(),

                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(40),
                                bottom: ScreenUtil().setHeight(70)),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: saqs?.length,
                            itemBuilder: (BuildContext context, int index) {
                              _getcheckedReadingItems();
                              return makeCardsaq(saqs?[index]);
                            },
                          );
                        } else {
                          return Container(
                              height: screenHeight,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isChecked = false;
  String label = '';
  Widget makeCard(reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title ?? "",
      indicatorValue: reading.indicatorValue,
      level: reading.level ?? "",
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": trueOrFalse?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(label, isChecked);
            print(prefs.getBool(label) ?? false);

            setState(() {
              isChecked = prefs.getBool(label) ?? false;

              if (checkedReadingItems.contains(label)) {
                checkedReadingItems.remove(label);
              } else {
                checkedReadingItems.add(label);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReadingDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  bool isCheckedsaq = false;
  String labelsaq = '';
  Widget makeCardsaq(ShortAnswer reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title,
      indicatorValue: 2,
      level: reading.level ?? '',
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": saqs?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(labelsaq, isCheckedsaq);
            print(prefs.getBool(labelsaq) ?? false);

            setState(() {
              isCheckedsaq = prefs.getBool(labelsaq) ?? false;

              if (checkedReadingItems.contains(labelsaq)) {
                checkedReadingItems.remove(labelsaq);
              } else {
                checkedReadingItems.add(labelsaq);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShortAnswerDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  bool isCheckedEnd = false;
  String labelEnd = '';
  Widget makeCardEnd(MatchEndings reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title ?? "",
      indicatorValue: 2,
      level: reading.level ?? '',
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": matchingEndings?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(labelEnd, isCheckedEnd);
            print(prefs.getBool(label) ?? false);

            setState(() {
              isCheckedEnd = prefs.getBool(labelEnd) ?? false;

              if (checkedReadingItems.contains(labelEnd)) {
                checkedReadingItems.remove(labelEnd);
              } else {
                checkedReadingItems.add(labelEnd);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchEndingsDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  bool isCheckedmcq = false;
  String labelmcq = '';
  Widget makeCardmcq(MCQs reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title,
      indicatorValue: reading.id.length,
      level: reading.level ?? '',
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": mcqs?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(labelmcq, isCheckedmcq);
            print(prefs.getBool(labelmcq) ?? false);

            setState(() {
              isCheckedmcq = prefs.getBool(labelmcq) ?? false;

              if (checkedReadingItems.contains(labelmcq)) {
                checkedReadingItems.remove(labelmcq);
              } else {
                checkedReadingItems.add(labelmcq);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MCQDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  bool isCheckedList = false;
  String labelList = '';
  Widget makeCardList(ListSelection reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title ?? "",
      indicatorValue: reading.id.length,
      level: reading.level ?? "",
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": listSelection?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(labelList, isCheckedList);
            print(prefs.getBool(labelList) ?? false);

            setState(() {
              isCheckedList = prefs.getBool(labelList) ?? false;

              if (checkedReadingItems.contains(labelList)) {
                checkedReadingItems.remove(labelList);
              } else {
                checkedReadingItems.add(labelList);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListSelectionDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  bool isCheckedsen = false;
  String labelsen = '';
  Widget makeCardsen(SentenceCompletion reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title ?? '',
      indicatorValue: 2,
      level: reading.level ?? '',
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": sentencecompletion?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(label, isChecked);
            print(prefs.getBool(label) ?? false);

            setState(() {
              isChecked = prefs.getBool(label) ?? false;

              if (checkedReadingItems.contains(label)) {
                checkedReadingItems.remove(label);
              } else {
                checkedReadingItems.add(label);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SentenceCompletionDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  bool isCheckedhed = false;
  String labelhed = '';
  Widget makeCardhed(HeadingCompletion reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title ?? "",
      indicatorValue: 2,
      level: reading.level ?? '',
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": sentencecompletion?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(label, isChecked);
            print(prefs.getBool(label) ?? false);

            setState(() {
              isChecked = prefs.getBool(label) ?? false;

              if (checkedReadingItems.contains(label)) {
                checkedReadingItems.remove(label);
              } else {
                checkedReadingItems.add(label);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HeadingCompletionDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  Widget makeCardsum(SummaryCompletion reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title ?? "",
      indicatorValue: 2,
      level: reading.level ?? "",
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": sentencecompletion?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(label, isChecked);
            print(prefs.getBool(label) ?? false);

            setState(() {
              isChecked = prefs.getBool(label) ?? false;

              if (checkedReadingItems.contains(label)) {
                checkedReadingItems.remove(label);
              } else {
                checkedReadingItems.add(label);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SummaryCompletionDetailScreen(reading: reading),
          ),
        );
      },
    );
  }

  Widget makeCardpara(MatchingParagraphs reading) {
    print('reading it listening ');

    return LessonCard(
      title: reading.title.toString(),
      indicatorValue: 2,
      level: reading.level ?? "",
      trailing: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20),
        child: FlutGroupedButtons(
          isRadio: true,
          idKey: 'id',
          valueKey: 'level',
          data: [
            {"id": paragraph?.length},
          ],
          checkColor: Colors.white,
          activeColor: Colors.black,
          labelStyle: TextStyle(fontSize: 0),
          onChanged: (index) async {
            print("Index: $index");
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool(label, isChecked);
            print(prefs.getBool(label) ?? false);

            setState(() {
              isChecked = prefs.getBool(label) ?? false;

              if (checkedReadingItems.contains(label)) {
                checkedReadingItems.remove(label);
              } else {
                checkedReadingItems.add(label);
              }
              prefs.setStringList('checkedReadingItems', checkedReadingItems);
              print(checkedReadingItems);
            });
          },
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MatchingParagraphsDetailScreen(reading: reading),
          ),
        );
      },
    );
  }
  // ListTile makeListTile(Reading reading) =>
}

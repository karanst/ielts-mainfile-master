// import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_grouped_buttons/flut_grouped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:grouped_buttons/grouped_buttons.dart';

import 'package:ielts/models/listening.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/listening_detail_screen.dart';
import 'package:ielts/services/admob_service.dart';
import 'package:ielts/viewModels/listeningCrudModel.dart';
import 'package:ielts/widgets/lessonCard.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/adsHelper.dart';

final Color backgroundColor = Color(0xFF21BFBD);

class ListeningScreen extends StatefulWidget {
  // ListeningScreen({Key key}) : super(key: key);

  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen>
    with SingleTickerProviderStateMixin {
  List? listening;

  bool isCollapsed = true;
  var screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);

  final ams = AdMobService();

  List<String> checkedListeningItems = [];

  void _getcheckedListeningItems() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('checkedListeningItems')) {
      checkedListeningItems = prefs.getStringList('checkedListeningItems')!;
    } else {
      prefs.setStringList('checkedListeningItems', checkedListeningItems);
    }
  }

  @override
  void initState() {
    _getcheckedListeningItems();
    super.initState();
    // Admob.initialize();
    ams.getAdMobAppId();
    // listening = getListeningData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _adController = NativeAdController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context);

//If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
//     ScreenUtil.init(context, width: 414, height: 896);

//If you want to set the font size is scaled according to the system's "font size" assist option
//     ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
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
        title: Text('Listening Exercises',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(20),
            )),
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottomOpacity: 0.0,
      ),
      body: dashboard(context),
    );
  }

  Widget dashboard(context) {
    final productProvider = Provider.of<ListeningCrudModel>(context);
    print('listeineg it ');
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('listening')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error fetching data'));
                    }

                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.length > 0) {
                      print('listeineg it listening ');
                      listening = snapshot.data!.docs
                          .map((doc) => Listening.fromMap(
                              doc.data() as Map<String, dynamic>, doc.id))
                          .toList();
                      print('data ${listening?[0].title}');
                      print('data length: ${listening?.length}');
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
                          itemCount: listening?.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return
                            // Center(child: Text('data okay ha '));
                            // print('data okay ha ${listening?[0].title}');
                            return makeCard(listening?[index]);
                          },
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ))
          ],
        ),
      ),
    );
  }

  Widget makeCard(Listening listening) {
    print('title new${listening.level}');
    return LessonCard(
      title: listening.title ?? '',
      // title: 'han g',
      indicatorValue: 2,
      level: listening.level ?? '',
      // level: 'fine',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListeningDetailScreen(listening: listening),
          ),
        );
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
              {"id": listening?.id, "level": listening?.level},
            ],
            checkColor: Colors.white,
            activeColor: Colors.black,
            labelStyle: TextStyle(fontSize: 0),
            onChanged: (index) async {
              String label = listening?.id ?? '';
              print('title new detais${listening.level}');
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool(label, prefs.getBool(label) ?? false);

              setState(() {
                bool isChecked = prefs.getBool(label) ?? false;

                if (checkedListeningItems.contains(label)) {
                  checkedListeningItems.remove(label);
                } else {
                  checkedListeningItems.add(label);
                }
                prefs.setStringList(
                    'checkedListeningItems', checkedListeningItems);
                print(checkedListeningItems);
              });
            },
          ),
        ),
      ),
    );
  }
}

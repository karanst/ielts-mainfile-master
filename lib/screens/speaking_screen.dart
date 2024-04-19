import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ielts/models/speaking.dart';
import 'package:ielts/screens/speaking_detail_screen.dart';
import 'package:ielts/widgets/lessonCard.dart';
import 'package:flut_grouped_buttons/flut_grouped_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/adsHelper.dart';

class SpeakingScreen extends StatefulWidget {
  @override
  _SpeakingScreenState createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen>
    with SingleTickerProviderStateMixin {
  List<Speaking>? speakings;
  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  List<String> checkedSpeakingItems = [];
  final NativeAdController _adController = NativeAdController();

  void _getcheckedSpeakingItems() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('checkedSpeakingItems')) {
      checkedSpeakingItems = prefs.getStringList('checkedSpeakingItems')!;
    } else {
      prefs.setStringList('checkedSpeakingItems', checkedSpeakingItems);
    }
  }

  @override
  void initState() {
    super.initState();
    _getcheckedSpeakingItems();
  }

  @override
  void dispose() {
    _adController.dispose();
    super.dispose();
  }

  Widget _buildFlutGroupedButtons(Speaking? speaking) {
    print('title new group buttn${speaking?.id}');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.all(20),
      child: FlutGroupedButtons(
        isRadio: true,
        idKey: 'id',
        valueKey: 'name',
        checkColor: Colors.white,
        activeColor: Colors.black,
        // data: [speaking?.id ?? ''],
        data: [
          {"id": speaking?.id, "name": speaking?.title},
        ],
        labelStyle: TextStyle(fontSize: 0),
        onChanged: (index) async {
          String label = speaking?.id ?? '';
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool(label, prefs.getBool(label) ?? false);

          setState(() {
            bool isChecked = prefs.getBool(label) ?? false;

            if (checkedSpeakingItems.contains(label)) {
              checkedSpeakingItems.remove(label);
            } else {
              checkedSpeakingItems.add(label);
            }
            prefs.setStringList('checkedSpeakingItems', checkedSpeakingItems);
            print(checkedSpeakingItems);
          });
        },
      ),
    );
  }

  Widget _buildCard(Speaking? speaking) {
    print('title new${speaking?.title}');
    return LessonCard(
      title: speaking?.title ?? '',
      indicatorValue: 2,
      level: speaking?.level ?? '',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeakingDetailScreen(speaking: speaking!),
          ),
        );
      },
      trailing: SizedBox(
        width: 100.0, // Adjust the width as needed
        child: _buildFlutGroupedButtons(speaking),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    return Material(
      animationDuration: const Duration(milliseconds: 300),
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('speaking')
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
                    speakings = snapshot.data!.docs
                        .map((doc) => Speaking.fromMap(
                            doc.data() as Map<String, dynamic>, doc.id))
                        .toList();
                    print('data ${speakings?[0].title}');

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
                        itemCount: speakings?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildCard(speakings?[index]);
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        'Speaking Exercises',
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(18),
        ),
      ),
      bottomOpacity: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);
    return Scaffold(
      bottomNavigationBar:
          _adController.ad != null && _adController.adLoaded.isTrue
              ? SizedBox(
                  height: 80,
                  child: AdWidget(ad: _adController.ad!),
                )
              : null,
      appBar: _buildAppBar(),
      body: _buildDashboard(context),
    );
  }
}

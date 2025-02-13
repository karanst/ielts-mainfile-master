import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:ielts/chat/screens/splach_screen.dart';

import 'package:ielts/screens/adverting/advertining_screen.dart';
import 'package:ielts/screens/pdf_viewer.dart';
import 'package:ielts/screens/teacher_list.dart';

import 'package:ielts/services/admob_service.dart';
import 'package:ielts/utils/app_constants.dart';
import 'package:ielts/widgets/adsHelper.dart';

import 'package:ielts/widgets/menu_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/auth.dart';
import '../widgets/facebookAds.dart';
import 'adverting/slider_2.dart';
import 'adverting/slider_3.dart';

final Color backgroundColor = Color(0xFF21BFBD);
// ignore: non_constant_identifier_names
bool premium_user = false;
bool premium_user_google_play = false;
var height, width;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  //navbar
  //       var appcastURL = 'https://www.mydomain.com/myappcast.xml';
  // final cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
  bool isCollapsed = true;
  var screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  var _controller;
  var _scaleAnimation;
  var _menuScaleAnimation;
  var _slideAnimation;
  late Stream<QuerySnapshot> imageStream;
  int currentSlideIndex = 0;
  CarouselController carouselController = CarouselController();
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  StreamSubscription? _conectionSubscription;
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;

  final ams = AdMobService();
  MyAds ads = MyAds();
  FacebookBannerAd? facebookBannerAd;
  @override
  void initState() {
    initPlatformState();
    getPremium();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection("TeacherData").snapshots();

    super.initState();
  }

  void getPremium() async {
    print("coming in premium users");
    final user = await FirebaseAuth.instance.currentUser;

    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('premium_users')
          .doc("1PgowTp00FvxrJPgw3Kz")
          // .doc(user?.uid)
          .get();

      setState(() {
        if (snap.exists) {
          print("snapshoot id: ${snap.id}");
          setState(() {
            premium_user = true;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  final List<String> _productLists = Platform.isAndroid
      ? [
          'vault_premium',
          'android.test.purchased',
          'android.test.canceled',
        ]
      : [
          'teacher1.ielts_20usd',
          'teacher2.ielts_50usd',
        ];

  Future _getProduct() async {
    print('getProduct: ${_productLists}');
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      this._purchases = [];
    });
  }

  Future<void> initPlatformState() async {
    // prepare
    // var result = await FlutterInappPurchase.instance.initialize();
    // print('result: $result');
    // if (!mounted) return;
    _getPurchaseHistory();
    await _getProduct();
    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('msg: $msg');
      // await _getProduct();
      premium_user_google_play = true;
      print('consumeAllItems: $msg');
    } catch (err) {
      premium_user_google_play = false;
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    print('purchased items: ${items}');
    for (var item in items!) {
      print('purchased items: ${item.toString()}');
      this._purchases.add(item);
    }

    // setState(() {
    this._items = [];
    this._purchases = items;
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List imgData = [
    "assets/readings.jpg",
    "assets/writings.jpg",
    "assets/listings.jpg",
    "assets/speakings.jpg",
    "assets/pdf.png",
    "assets/quizs.png"
  ];
  List titles = [
    "reading",
    "writing",
    "listening",
    "speaking",
    "Books",
    "Quizes",
  ];

  void navigateToSection(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(RoutePaths.reading);
        break;
      case 1:
        Navigator.of(context).pushNamed(RoutePaths.writing);
        break;
      case 2:
        Navigator.of(context).pushNamed(RoutePaths.listening);
        break;
      case 3:
        Navigator.of(context).pushNamed(RoutePaths.speaking);

        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => PDF()));
        break;
      case 5:
        Navigator.of(context).pushNamed(RoutePaths.quiz);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    ScreenUtil.init(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              // color: Color.fromARGB(255, 221, 12, 144),
              // width: width,
              // height: height,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    // height: height * 0.25,
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 15,
                            right: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Handle sorting action
                                  Get.offAll(() => MenuPage(userId: userId));
                                },
                                child: Icon(
                                  Icons.sort,
                                  color: Colors.teal,
                                  size: 40,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Handle settings navigation
                                  Navigator.pushNamed(
                                      context, RoutePaths.settings);
                                },
                                child: Icon(Icons.settings),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeacherList()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      // height: height * 0.55,
                      width: width,
                      padding: EdgeInsets.symmetric(),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Meet Our ',
                                      style: TextStyle(
                                        color: Colors
                                            .black, // Default color for text
                                        fontSize: 24.0, // Set text size
                                      ),
                                    ),
                                    Text(
                                      'Teacher',
                                      style: TextStyle(
                                        color: Colors
                                            .blue, // Blue color for "Teacher"
                                        fontWeight: FontWeight
                                            .bold, // Optional: make "Teacher" bold
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/teacherPro.jpeg", fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    // height: MediaQuery.of(context).size.height*0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.1,
                                // mainAxisSpacing: 5,
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: imgData.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (!premium_user_google_play) {
                                      ads.showInterstitialAd();
                                      AdHelper.initAds();
                                      AdHelper.showInterstitialAd(
                                          onComplete: () {
                                        navigateToSection(index);
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Image.asset(
                                          imgData[index],
                                          width: 100,
                                        ),
                                        Text(
                                          titles[index],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.chat),
        //       label: 'Chat',
        //     ),
        //   ],
        //   currentIndex: _selectedIndex,
        //   selectedItemColor: Colors.amber[800],
        //   onTap: _onItemTapped,
        // ),
      ),
    );
  }
}

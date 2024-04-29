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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ielts/chat/api/apis.dart';
import 'package:ielts/chat/screens/chat_main_screen.dart';

import 'package:ielts/chat/screens/splach_screen.dart';

import 'package:ielts/screens/adverting/advertining_screen.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/login_screen.dart';
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

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
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
  List<Widget> items=[ HomeScreen(), TeacherList(),  APIs.auth.currentUser != null ? ChatMainScreen() : SplashScreens() ];
  @override
  void initState() {
    print("Home screen init state");
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
      : [    'teacher1.ielts_20usd',
    'teacher2.ielts_50usd',];

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

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // InterstitialAd? interstitialAd;
  // final String interstitialAdUnitId = Config.interstitialAds;

  // InterstitialAd? interstitialAd;
  // final String interstitialAdUnitId = Config.interstitialAds;

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
    "PDF",
    "Quizes",
  ];

  // Function to dynamically navigate based on the index
  void navigateToSection(int index) {
    // You can place your ad logic here if needed
    // Navigate to the appropriate section based on the index
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
      // Navigator.of(context).pushNamed(RoutePaths.speaking);
        Navigator.of(context).pushNamed(RoutePaths.start);

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

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation to different pages here
    // Example:
    // if (index == 2) {
    //   if (APIs.auth.currentUser != null) {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (_) => ChatMainScreen()));
    //   } else {
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (_) => LoginScreen1(title: 'Login',)));
    //   }
    // }
  }
  DateTime timeBackPressed = DateTime.now();

  exitConfirmationDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Exit App'),
      content: const Text('Are you sure you want to exit?'),
      actions: [
        InkWell(
          onTap: (){
            Navigator.of(context).pop(true);
          },
          child: Container(
            width: 67,
            height: 32,
            decoration: ShapeDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF178FFF), Color(0x661D8CF2)],
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0x7F499CC0)),
                borderRadius: BorderRadius.circular(8),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child:  const Center(
                child: Text(
                  'YES',
                  style: TextStyle(color: Colors.white),
                )) ,
          ),
        ),  InkWell(
          onTap: (){
            Navigator.of(context).pop(false);
          },
          child: Container(
            width: 67,
            height: 32,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0xFF178FFF), Color(0x661D8CF2)],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0x7F499CC0)),
                borderRadius: BorderRadius.circular(8),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child:  const Center(
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.white),
                )) ,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    ScreenUtil.init(context);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return PopScope(
        onPopInvoked: (bool v) async {
          final shouldExit = await showDialog(
            context: context,
            builder: (context) => exitConfirmationDialog(),
          );
          return shouldExit ?? false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: items[_selectedIndex],

          // SingleChildScrollView(
          //   child: SafeArea(
          //     child: Container(
          //       // color: Color.fromARGB(255, 221, 12, 144),
          //       // width: width,
          //       // height: height,
          //       child: Column(
          //         children: [
          //           Container(
          //             decoration: BoxDecoration(),
          //             // height: height * 0.25,
          //             width: width,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.only(
          //                     top: 15,
          //                     left: 15,
          //                     right: 15,
          //                   ),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                     children: [
          //                       InkWell(
          //                         onTap: () {
          //                           // Handle sorting action
          //                           Get.offAll(() => MenuPage(userId: userId));
          //                         },
          //                         child: Icon(
          //                           Icons.sort,
          //                           color: Colors.teal,
          //                           size: 40,
          //                         ),
          //                       ),
          //                       InkWell(
          //                         onTap: () {
          //                           // Handle settings navigation
          //                           Navigator.pushNamed(
          //                               context, RoutePaths.settings);
          //                         },
          //                         child: Container(
          //                           height: 50,
          //                           width: 50,
          //                           decoration: BoxDecoration(
          //                             color: Colors.white,
          //                             borderRadius: BorderRadius.circular(15),
          //                             image: DecorationImage(
          //                               image: AssetImage('assets/woman.png'),
          //                             ),
          //                           ),
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //
          //           // Body
          //           GestureDetector(
          //             onTap: (){
          //               Navigator.push(context, MaterialPageRoute(builder: (context) =>TeacherList()));
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.only(
          //                     topLeft: Radius.circular(30),
          //                     topRight: Radius.circular(30),
          //                   )),
          //               // height: height * 0.55,
          //               width: width,
          //               padding: EdgeInsets.symmetric(),
          //               child: Column(
          //                 children: [
          //
          //                   Container(
          //                     margin: EdgeInsets.symmetric(
          //                         vertical: 8, horizontal: 20),
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(20),
          //                       color: Colors.white,
          //                       boxShadow: [
          //                         BoxShadow(
          //                           color: Colors.black26,
          //                           spreadRadius: 1,
          //                           blurRadius: 6,
          //                         ),
          //                       ],
          //                     ),
          //                     child: Row(
          //                       mainAxisAlignment:
          //                       MainAxisAlignment.spaceEvenly,
          //                       children: [
          //
          //                         Column(
          //                           children: [
          //                             Text(
          //                               'Meet Our ',
          //                               style: TextStyle(
          //                                 color: Colors.black, // Default color for text
          //                                 fontSize: 24.0, // Set text size
          //                               ),),
          //                             Text(
          //                               'Teacher',
          //                               style: TextStyle(
          //                                 color: Colors.blue, // Blue color for "Teacher"
          //                                 fontWeight: FontWeight.bold, // Optional: make "Teacher" bold
          //                               ),
          //                             ),
          //
          //                           ],
          //                         ),
          //
          //                         Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Image.asset(
          //                             "assets/teacherPro.jpeg",fit: BoxFit.cover,
          //                             width: MediaQuery.of(context).size.width*0.4,
          //                             // height: MediaQuery.of(context).size.height*0.2,
          //                           ),
          //                         ),
          //
          //
          //
          //                       ],
          //                     ),
          //                   ),
          //
          //
          //                   SingleChildScrollView(
          //                     child: GridView.builder(
          //                       gridDelegate:
          //                       SliverGridDelegateWithFixedCrossAxisCount(
          //                         crossAxisCount: 2,
          //                         childAspectRatio: 1.1,
          //                         // mainAxisSpacing: 5,
          //                       ),
          //                       shrinkWrap: true,
          //                       physics: NeverScrollableScrollPhysics(),
          //                       itemCount: imgData.length,
          //                       itemBuilder: (context, index) {
          //                         return InkWell(
          //                           onTap: () {
          //                             if (!premium_user_google_play) {
          //                               ads.showInterstitialAd();
          //                               AdHelper.initAds();
          //                               AdHelper.showInterstitialAd(
          //                                   onComplete: () {
          //                                     navigateToSection(index);
          //                                   });
          //                             }
          //                           },
          //                           child:
          //                           Container(
          //                             margin: EdgeInsets.symmetric(
          //                                 vertical: 8, horizontal: 20),
          //                             decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(20),
          //                               color: Colors.white,
          //                               boxShadow: [
          //                                 BoxShadow(
          //                                   color: Colors.black26,
          //                                   spreadRadius: 1,
          //                                   blurRadius: 6,
          //                                 ),
          //                               ],
          //                             ),
          //                             child: Column(
          //                               mainAxisAlignment:
          //                               MainAxisAlignment.spaceEvenly,
          //                               children: [
          //                                 Image.asset(
          //                                   imgData[index],
          //                                   width: 100,
          //                                 ),
          //                                 Text(
          //                                   titles[index],
          //                                   style: TextStyle(
          //                                     fontSize: 20,
          //                                     fontWeight: FontWeight.bold,
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         );
          //                       },
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Teachers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ));
  }
}

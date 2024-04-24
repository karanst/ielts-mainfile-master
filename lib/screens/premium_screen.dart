import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ielts/utils/app_constants.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumScreen extends StatefulWidget {
  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _premiumUser = false;
  InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<dynamic> _streamSubscription;
  List<ProductDetails> _products = [];
  static const _variants = {'Gold', 'Silver'};
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;
  StreamSubscription? _conectionSubscription;
  final List<String> _productLists = Platform.isAndroid
      ? [
          'vault_premium',
          'android.test.purchased',
          'android.test.canceled',
        ]
      : [    'teacher1.ielts_20usd',
    'teacher2.ielts_50usd',];

  // final List<String> _productLists = Platform.isAndroid
  //     // ? [
  //     //     'vault_premium',
  //     //   ]
  //     // : ['com.cooni.point1000', 'com.cooni.point5000'];
  //     ? [
  //   'vault_premium',
  //   'android.test.purchased',
  //   // 'point_2000',
  //   // '8000_point',
  //   'android.test.canceled',
  // ]
  //     : ['com.cooni.point1000', 'com.cooni.point5000'];
  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  @override
  void initState() {
    super.initState();
    // isUserLoggedIn();
    _initIAP();
    initPlatformState();
    // _initializeInAppPurchase();
    //   this._getProduct();

    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseList) {
      _listenToPurchase(purchaseList, context);
    }, onDone: () {
      _streamSubscription.cancel();
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Occurred')));
    });
    fetchProductDetails();
    // _getPurchases();
  }

  @override
  void dispose() {
    if (_conectionSubscription != null) {
      _conectionSubscription?.cancel();
      _conectionSubscription;
    }
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  /*Future<void> initPlatformState() async {
    String platformVersion='';
    // Platform messages may fail, so we use a try/catch PlatformException.

    final user = await FirebaseAuth.instance.currentUser;

    try {
      // platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    // consumallItem
    var result = await FlutterInappPurchase.instance.consumeAll();
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      await FirebaseFirestore.instance
          .collection('premium_users')
          .doc(user?.uid)
          .set({
        "premium_user": true,
        "transactionDate": productItem?.transactionDate,
        "transactionId": productItem?.transactionId,
        "purchaseToken": productItem?.purchaseToken,
        // "orderId": productItem.orderId,
        "transactionReceipt": productItem?.transactionReceipt,
        "productId": productItem?.productId,
        "userId": user?.uid,
        "userEmail": user?.email,
        "userName": user?.displayName
      });

      setState(() {
        _premiumUser = true;
        premium_user = true;
      });

      await FlutterInappPurchase.instance.finishTransaction(
        productItem!,
        // developerPayloadAndroid: productItem.developerPayloadAndroid,
        isConsumable: false,
      );

      await FlutterInappPurchase.instance
          .acknowledgePurchaseAndroid(productItem.purchaseToken??'');

      Navigator.pushReplacementNamed(context, RoutePaths.home);
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }*/
  Future<void> initPlatformState() async {
    // prepare
    // var result = await FlutterInappPurchase.instance.initialize();
    // print('result: $result');
    // if (!mounted) return;
    _getPurchaseHistory();
    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      await _getProduct();
      print('consumeAllItems: $msg');
    } catch (err) {
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

  // List<Widget> _renderInApps() {
  //   List<Widget> widgets = this
  //       ._items
  //       .map((item) => Container(
  //     margin: EdgeInsets.symmetric(vertical: 10.0),
  //     child: Container(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             margin: EdgeInsets.only(bottom: 5.0),
  //             child: Text(
  //               item.toString(),
  //               style: TextStyle(
  //                 fontSize: 18.0,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //           MaterialButton(
  //             color: Colors.orange,
  //             onPressed: () {
  //               print("---------- Buy Item Button Pressed");
  //               this._requestPurchase(item);
  //             },
  //             child: Row(
  //               children: <Widget>[
  //                 Expanded(
  //                   child: Container(
  //                     height: 48.0,
  //                     alignment: Alignment(-1.0, 0.0),
  //                     child: Text('Buy Item'),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ))
  //       .toList();
  //   return widgets;
  // }

  void _requestPurchase(IAPItem item) async {
    print('requestPurchase: ${item.toString()}');
    FlutterInappPurchase.instance.requestPurchase(item.productId ?? "");
  }

  void _initializeInAppPurchase() async {
    // Initialize FlutterInappPurchase here
    await FlutterInappPurchase.instance.initialize();
  }

/*
  Future _getProduct() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(_productLists);
    print('items: $items');
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      this._purchases = [];
    });
  }
*/

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

  Future _getPurchases() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  Future<void> _initIAP() async {
    try {
      await FlutterInappPurchase.instance.initialize();
    } catch (e) {
      print('Failed to initialize in-app purchase: $e');
    }
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
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
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

//If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
//     ScreenUtil.init(context, width: 414, height: 896);

//If you want to set the font size is scaled according to the system's "font size" assist option
//     ScreenUtil.init(context, width: 414, height: 896, allowFontScaling: true);
    double screenWidth = MediaQuery.of(context).size.width - 20;
    double buttonWidth = (screenWidth / 3) - 20;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, RoutePaths.home);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.all(7.0),
          child: ListView(
            children: <Widget>[
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: <Widget>[
              //     Column(
              //       children: this._renderInApps(),
              //     ),
              //   ],
              // ),
              IconButton(
                alignment: Alignment.topLeft,
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.black,
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, RoutePaths.home),
              ),
              Image(
                image: AssetImage(
                  "assets/premium.jpg",
                ),
                height: ScreenUtil().setHeight(110),
                width: double.infinity,
              ),
              Text(
                'YAN Premium',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(20)),
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.deepPurpleAccent,
                ),
                title: Text(
                  'No Ads',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Concentrate just on studying!',
                  style: TextStyle(
                      color: Colors.black87, fontSize: ScreenUtil().setSp(14)),
                ),
              ),

              ListTile(
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.deepPurpleAccent,
                ),
                title: Text(
                  'Unlock Unlimited chat with other students',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Ask questions, get help, essay reviews',
                  style: TextStyle(
                      color: Colors.black87, fontSize: ScreenUtil().setSp(14)),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.deepPurpleAccent,
                ),
                title: Text(
                  'Unlock Unlimited Books',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'More then 100 + premium books  for you to read and study in pdf form.',
                  style: TextStyle(
                      color: Colors.black87, fontSize: ScreenUtil().setSp(14)),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.deepPurpleAccent,
                ),
                title: Text(
                  'Support Development',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Your help keeps us working on this project further,',
                  style: TextStyle(
                      color: Colors.black87, fontSize: ScreenUtil().setSp(14)),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.deepPurpleAccent,
                ),
                title: Text(
                  'Start now',
                  style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Cheapest price in IELTS field.',
                  style: TextStyle(
                      color: Colors.black87, fontSize: ScreenUtil().setSp(14)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: _button(),
                  ),
                ],
              ),

              Container(
                  width: buttonWidth,
                  height: 40.0,
                  margin: EdgeInsets.all(5.0),
                  child: MaterialButton(
                    color: Colors.green,
                    padding: EdgeInsets.all(0.0),
                    onPressed: () {
                      // _requestPurchase(item);
                      print("---------- Get Items Button Pressed");
                      // if (!isUserLoggedIn()) {
                      //
                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     // _scaffoldKey.currentState.showSnackBar(SnackBar(
                      //       content: InkWell(
                      //         onTap: () {
                      //           signOutGoogle(context);
                      //         },
                      //         child: Row(
                      //           children: [
                      //             Text(
                      //               'You need to login to purchase premium',
                      //             ),
                      //             Text(
                      //               'Login Now',
                      //               style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.bold),
                      //             )
                      //           ],
                      //         ),
                      //       ))
                      //   );
                      // }else{
                      //   print("object");
                      //  //   _requestPurchase(_items[0]);
                      //  // this._button();
                      //   this._getProduct();
                      buy(context);
                      // this._getProduct();
                      // this._button();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment(0.0, 0.0),
                      child: Text(
                        'coming soon',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ),
                  )),
/*
              ElevatedButton(onPressed: (){

                if (!isUserLoggedIn()) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    // _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: InkWell(
                        onTap: () {
                          signOutGoogle(context);
                        },
                        child: Row(
                          children: [
                            Text(
                              'You need to login to purchase premium',
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Login Now',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ))
                  );
                } else {
                  this._requestPurchase(_items[0]);

                }
              }, child: Text('Buy Now')),
*/
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _button() {
    List<Widget> widgets = this
        ._items
        .map((item) => Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                        child: TextButton(
                          onPressed: () async {
                            // final FirebaseAuth _auth = FirebaseAuth.instance;
                            // final User? user = await _auth.currentUser;
                            // var userName;
                            // var document = FirebaseFirestore.instance
                            //     .collection('users')
                            //     .doc(user?.uid);
                            // await document.snapshots().forEach((element) {
                            // userName = element.data["firstName"];
                            // userName = element.data;
                            // print(userName);
                            // if (!isUserLoggedIn()) {
                            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //   // _scaffoldKey.currentState.showSnackBar(SnackBar(
                            //       content: InkWell(
                            //     onTap: () {
                            //       signOutGoogle(context);
                            //     },
                            //     child: Row(
                            //       children: [
                            //         Text(
                            //           'You need to login to purchase premium',
                            //         ),
                            //         SizedBox(
                            //           width: 10,
                            //         ),
                            //         Text(
                            //           'Login Now',
                            //           style: TextStyle(
                            //               color: Colors.black,
                            //               fontWeight: FontWeight.bold),
                            //         )
                            //       ],
                            //     ),
                            //   ))
                            //   );
                            // } else {
                            this._requestPurchase(item);

                            // });
                            // print(userName);
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(300),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(15)),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.deepPurpleAccent),
                            child: FittedBox(
                              child: Text(
                                'Get for ${item.currency} ${item.localizedPrice}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(20),
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
    return widgets;
  }

  // Check if a user is logged in
  bool isUserLoggedIn() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  //
  // Widget purchaseButton(IAPItem item) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       _requestPurchase(item);
  //     },
  //     child: Text('Purchase'),
  //   );
  // }
  // ProductDetails yourItem = ProductDetails(
  //   id: 'your_product_id',
  //   title: 'Your Product Title',
  //   description: 'Description of your product',
  //   price: 'your_product_price',
  //   currencyCode: 'dollar', rawPrice: 200,
  // );
  Future<void> fetchProductDetails() async {
    // Replace these product IDs with your actual product IDs from Google Play Console
    Set<String> productIds = {'one_month', 'one_year'};
    print("Product IDs: $productIds");
    ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(productIds);
    if (productDetailsResponse.error == null) {
      print(
          'Product details: ${productDetailsResponse.productDetails.last.price}.');
      setState(() {
        _products = productDetailsResponse.productDetails;
      });
    } else {
      debugPrint(
          'Failed to fetch product details: ${productDetailsResponse.error}');
    }
  }

  void _listenToPurchase(
      List<PurchaseDetails> purchaseDetailsList, BuildContext context) async {
    print('Purchase productID: ${purchaseDetailsList.first.purchaseID}');
    // if(purchaseDetailsList.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase Completed')));
    // }

    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      try {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Pending')));
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Some Error Occurred')));
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Purchase Completed')));
        }
      } catch (error) {
        print('Error handling purchase: $error');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An error occurred while processing the purchase')));
      }
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // ._showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          // _deliverProduct(purchaseDetails);
          // }
          // else {
          //     // _handleInvalidPurchase(purchaseDetails);
          //   }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void buy(BuildContext context) {
    if (_products.isNotEmpty) {
      print('Product length: ${_products.length}');
      final ProductDetails productDetails = _products[1];
      final PurchaseParam param = PurchaseParam(productDetails: productDetails);
      _inAppPurchase.buyConsumable(purchaseParam: param);
    } else {
      debugPrint('Unable to find elements');
    }
  }

  // void checkIfPurchased() async {
  //   final InAppPurchase _connection = InAppPurchase.instance;
  //
  //   // Check if available
  //   final bool available = await _connection.isAvailable();
  //   if (!available) {
  //     // The store is not available or something went wrong.
  //     return;
  //   }
  //
  //   // Product ID of the item you want to check
  //   String productId = 'your_product_id_here';
  //
  //   // Query the product details
  //   ProductDetailsResponse productDetailsResponse =
  //   await _connection.queryProductDetails(Set<String>.from([productId]));
  //
  //   // Check if there's an error
  //   if (productDetailsResponse.error != null) {
  //     // Handle error
  //     return;
  //   }
  //
  //   // Check if the product details are available
  //   if (productDetailsResponse.productDetails.isEmpty) {
  //     // Product details are not available
  //     // This may happen if the product ID is incorrect or not configured properly
  //     return;
  //   }
  //
  //   // Retrieve the product details
  //   ProductDetails productDetails = productDetailsResponse.productDetails.first;
  //
  //   // Check if the product has been purchased
  //   bool isPurchased = await _connection.isPurchased(productDetails.id);
  //
  //   if (isPurchased) {
  //     // Product has been purchased
  //     print('User has purchased $productId');
  //   } else {
  //     // Product has not been purchased
  //     print('User has not purchased $productId');
  //   }
  // }
}

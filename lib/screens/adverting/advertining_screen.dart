import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:ielts/chat/models/chat_user.dart';
import 'package:ielts/chat/screens/auth/login_screen.dart';
import 'package:ielts/chat/widgets/teacher_group_chat_widget.dart';
import 'package:ielts/services/auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../chat/models/message.dart';
import '../login_screen.dart';
import '../premium_screen.dart';

class AdvertisingScreen extends StatefulWidget {
  AdvertisingScreen({required this.snap, Key? key});
  DocumentSnapshot? snap;
  @override
  State<AdvertisingScreen> createState() => _AdvertisingScreenState();
}

class _AdvertisingScreenState extends State<AdvertisingScreen> {
  late YoutubePlayerController _controller;
  String title = "";
  String discription1 = "";
  String discription2 = "";
  String enrollNow = "https://wa.me/+919612052091";
  String name = "";
  String liveClass = "";
  String price = "";
  String duration = "";
  String flag = "";
  String productId = "";
  bool showFullDescription1 = false;
  bool showFullDescription2 = false;
  String user = "";
  String message = "";
  bool checkChat = false;
  void _launchWhatsApp() async {
    // Replace "YOUR_PHONE_NUMBER" with your actual phone number
    String phoneNumber = "+919612052091";
    // Replace "YOUR_MESSAGE" with your desired default message

    // WhatsApp link format: whatsapp://send?phone=+123456789&text=Hello
    String url = "https://wa.me/$phoneNumber?text=$message";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<IAPItem> _items = [];

  // Instantiates inAppPurchase
  final InAppPurchase _iap = InAppPurchase.instance;

  // checks if the API is available on this device
  bool _isAvailable = false;

  // keeps a list of products queried from Playstore or app store
  List<ProductDetails> _products = [];

  // List of users past purchases
  // List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];
  // List<PurchaseDetails> _purchases = [];

  // subscription that listens to a stream of updates to purchase details
  late StreamSubscription _subscription;

  // Method to retrieve product list
  Future<void> _getUserProducts(String prodId) async {
    Set<String> ids = {prodId};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  // Method to retrieve users past purchase
  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    print('purchased items: ${items}');
    for (PurchasedItem item in items!) {
      print('purchased items: ${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  // checks if a user has purchased a certain product
  // PurchaseDetails _hasUserPurchased(String productID){
  //   return _purchases.firstWhere((purchase) => purchase.productID == productID);
  // }

  // Method to check if the product has been purchased already or not.
  // void _verifyPurchases(){
  //   PurchaseDetails purchase = _hasUserPurchased('testID');
  //   if(purchase.status == PurchaseStatus.purchased){
  //     _coins = 10;
  //   }
  // }

  // Method to purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  @override
  void initState() {
    // _initialize();
    _getPurchaseHistory();
    fetchVideoIdFromFirestore();
    addGroup(widget
        .snap!.id); // using for create new group if group is not available
    checkCurrentUserForGroupMember();
    super.initState();
  }

  @override
  void dispose() {
    // cancelling the subscription
    _subscription.cancel();

    super.dispose();
  }

  void fetchVideoIdFromFirestore() async {
    print("-----------------------------------------------${widget.snap!.id}");
    // try {
    // DocumentSnapshot document = await FirebaseFirestore.instance
    //     .collection('TeacherData')
    //     .doc(widget.snap!.id) // Replace with your document ID
    //     .get();
    String videoId = widget.snap!['video_id'];
    title = widget.snap!['title'];
    discription1 = widget.snap!['description_1'];
    discription2 = widget.snap!['description_2'];
    name = widget.snap!['name'];
    liveClass = widget.snap!['liveClass'];
    print('rrrrrrrrrrrrrrrrr');
    print(name);
    message = widget.snap!['message'];
    price = widget.snap!['price'];
    duration = widget.snap!['duration'];
    flag = widget.snap!['flag'];
    enrollNow = widget.snap!['enroll_now'];
    productId = widget.snap!['productId'];
    _controller = YoutubePlayerController(
      initialVideoId: widget.snap!['video_id'],
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    setState(() {});
    _getUserProducts(productId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            title: Text(
              "Teacher Panel",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
            backgroundColor: Colors.transparent,
            // elevation: _appBarElevation,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: EdgeInsets.all(14),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 24, // Adjust the font size as needed
                      fontWeight: FontWeight.bold, // Make the name bold
                    ),
                  ),
                  SizedBox(
                    width:
                        5, // Add some spacing between the verification icon and the flag icon
                  ),
                  Icon(
                    Icons.verified,
                    color: Colors.blue, // Color of the verification icon
                    size: 20, // Size of the verification icon
                  ),
                  SizedBox(
                    width:
                        8, // Add some spacing between the verification icon and the flag icon
                  ),
                  // Display country flag icon here (use CachedNetworkImage or similar for efficient loading)
                  Image.network(
                    flag,
                    width: 24, // Adjust width as needed
                    height: 24, // Adjust height as needed
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Certified",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.bold, // Make the name bold
                      fontFamily: 'Montserrat', // Use a different font family
                      // Add underline decoration
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Price",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 14, // Adjust the font size as needed
                      fontWeight: FontWeight.bold, // Make the name bold
                      fontFamily: 'Montserrat', // Use a different font family
                      // Add underline decoration
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    price,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Duration",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 14, // Adjust the font size as needed
                      fontWeight: FontWeight.bold, // Make the name bold
                      fontFamily: 'Montserrat', // Use a different font family
                      // Add underline decoration
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    duration,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Course Details",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          color: Colors.teal), // Icon before text
                      SizedBox(width: 8),
                      Text(
                        liveClass,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        "Daily Doubt Clear Sessions",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            showFullDescription1
                                ? discription1
                                : '${discription1.split(' ').take(20).join(' ')}...',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Your other widgets...
                              if (discription1.length >
                                  20) // Only show buttons if description is longer than 20 characters
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (!showFullDescription1)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            showFullDescription1 = true;
                                          });
                                        },
                                        child: Text(
                                          'See More',
                                          style: TextStyle(
                                            color: Colors
                                                .teal, // Adjust text color as needed
                                            fontWeight: FontWeight
                                                .bold, // Make the text bold
                                          ),
                                        ),
                                      ),
                                    if (showFullDescription1)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            showFullDescription1 = false;
                                          });
                                        },
                                        child: Text(
                                          'See Less',
                                          style: TextStyle(
                                            color: Colors
                                                .teal, // Adjust text color as needed
                                            fontWeight: FontWeight
                                                .bold, // Make the text bold
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            showFullDescription2
                                ? discription2
                                : '${discription2.split(' ').take(20).join(' ')}...',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Your other widgets...
                              if (discription2.length >
                                  20) // Only show buttons if description is longer than 20 characters
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (!showFullDescription2)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            showFullDescription2 = true;
                                          });
                                        },
                                        child: Text(
                                          'See More',
                                          style: TextStyle(
                                            color: Colors
                                                .teal, // Adjust text color as needed
                                            fontWeight: FontWeight
                                                .bold, // Make the text bold
                                          ),
                                        ),
                                      ),
                                    if (showFullDescription2)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            showFullDescription2 = false;
                                          });
                                        },
                                        child: Text(
                                          'See Less',
                                          style: TextStyle(
                                            color: Colors
                                                .teal, // Adjust text color as needed
                                            fontWeight: FontWeight
                                                .bold, // Make the text bold
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        checkChat
                            ? GestureDetector(
                                onTap: () async {
                                  checkCurrentUserForAddMember();
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) =>TeacherGroup(teacherId: widget.snap!.id)));
                                },
                                child: ElevatedButton(
                                  onPressed: null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      "Chat Now",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  checkCurrentUserForAddMember();
                                },
                                child: ElevatedButton(
                                  onPressed: null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      "Enroll Now",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  //chat
                  Container(
                    child: ElevatedButton.icon(
                      onPressed:
                          _launchWhatsApp, // Call _launchWhatsApp when button is pressed
                      icon: Icon(Icons.message), // WhatsApp icon
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        child: Text(
                          "Chat Now",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkCurrentUserForGroupMember() {
    print('1');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      checkGroupMember();
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
          'teacher3.ielts_35usd',
        ];

  void checkCurrentUserForAddMember() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      if (checkChat) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TeacherGroup(teacherId: widget.snap!.id)));
      } else {
        if (_purchases.isEmpty) {
          _buyProduct(_products[0]);
        } else {
          addMember(widget.snap!.id);
        }
      }

      // else{
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PremiumScreen(),
      //     ),
      //   );
      // }
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginScreen1(title: '')));
    }
  }

  Future<bool> checkGroupMember() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Teacher")
        .doc(widget.snap!.id)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      List<String> membersID = List<String>.from(data!['membersID']);

      if (membersID.contains(auth.currentUser!.uid)) {
        setState(() {
          checkChat = true;
        });
        print('Member In');
      } else {
        setState(() {
          checkChat = false;
          print('member not in');
        });
      }
    }
    return false;
  }

  Future<void> addMember(teacherId) async {
    DateTime dateTime = DateTime.now();
    Timestamp specificTimeStamp = Timestamp.fromDate(dateTime);
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();
    List<RecentChat> recentChats = [
      RecentChat(
          id: auth.currentUser!.uid, // In Add group id is teacher Id
          message: 'Hi'),
    ];

    List<ChatRoomMember> members = [
      ChatRoomMember(
        userId: document.id,
        name: document["name"],
        imageUrl: 'https://example.com/profile1.jpg',
        isAdmin: false,
      ),
    ];

    final GroupMessages message = GroupMessages(
      name: document['name'],
      msg: "Hi",
      read: '',
      type: Type.text,
      sent: time,
      fromid: auth.currentUser!.uid,
      toId: auth.currentUser!.uid,
    );
    List<Map<String, dynamic>> recentChatData =
        recentChats.map((recentChat) => recentChat.toMap()).toList();
    List<Map<String, dynamic>> membersMap =
        members.map((member) => member.toMap()).toList();
    try {
      await FirebaseFirestore.instance
          .collection("Teacher")
          .doc(teacherId)
          .set({
        'RecentChat': FieldValue.arrayUnion(recentChatData),

        'membersID': FieldValue.arrayUnion(
            members.map((member) => member.userId).toList()),
        // List of user IDs
        'members': FieldValue.arrayUnion(membersMap),

        // List of members as maps
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance
          .collection("Teacher")
          .doc(teacherId)
          .collection("Chat")
          .doc(time)
          .set(message.toJson())
          .then((value) => setState(() {
                checkChat = true;
              }));
      await FirebaseFirestore.instance
          .collection("Teacher")
          .doc(teacherId)
          .update({
        "Timestamp": specificTimeStamp,
      });
      print('Document added to the new collection');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<void> addGroup(teacherId) async {
    DateTime dateTime = DateTime.now();
    Timestamp specificTimeStamp = Timestamp.fromDate(dateTime);

    List<RecentChat> recentChats = [
      RecentChat(
          id: teacherId, // In Add group id is teacher Id
          message: 'Hi'),
    ];
    List<Map<String, dynamic>> recentChatData =
        recentChats.map((recentChat) => recentChat.toMap()).toList();
    List<ChatRoomMember> members = [
      ChatRoomMember(
        userId: teacherId,
        name: name,
        imageUrl: 'https://example.com/profile1.jpg',
        isAdmin: true,
      ),
    ];
    List<Map<String, dynamic>> membersMap =
        members.map((member) => member.toMap()).toList();

    // Reference to the Firestore instance
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Teacher')
          .where('GroupId', isEqualTo: teacherId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print("doc is already created");
      } else {
        final time = DateTime.now().microsecondsSinceEpoch.toString();
        print(name);
        final GroupMessages message = GroupMessages(
          name: name,
          msg: "Hi",
          read: '',
          type: Type.text,
          sent: time,
          fromid: widget.snap!.id,
          toId: widget.snap!.id,
        );
        try {
          await firestore.collection("Teacher").doc(teacherId).set({
            "Timestamp": specificTimeStamp,
            "RecentChat": recentChatData,
            'GroupId': teacherId,
            'GroupTitle': name,
            "GroupImage": "https://example.com/profile1.jpg",
            'membersID': members
                .map((member) => member.userId)
                .toList(), // List of user IDs
            'members': membersMap,
            // List of members as maps
          });

          await firestore
              .collection("Teacher")
              .doc(teacherId)
              .collection("Chat")
              .doc(time)
              .set(message.toJson());
          print('Document added to the new collection');
        } catch (e) {
          print('Error adding document: $e');
        }
      }
    } catch (e) {
      // Handle any errors that occur during the query.
      print('An error occurred while querying Firestore: $e');
    }
  }

  void _redirectToWhatsApp(BuildContext context) async {
    final url = enrollNow;
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }
}

class ChatRoomMember {
  // Required fields
  final String userId; // User ID of the member
  final String name; // Name of the member
  final String imageUrl; // URL of the member's profile image
  final bool isAdmin; // Indicates if the member is an admin

  // Constructor to initialize the fields
  ChatRoomMember({
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.isAdmin,
  });

  // Method to convert the class instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'isAdmin': isAdmin,
    };
  }

  // Factory method to create an instance from a Map
  factory ChatRoomMember.fromMap(Map<String, dynamic> map) {
    return ChatRoomMember(
      userId: map['userId'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      isAdmin: map['isAdmin'] as bool,
    );
  }
}

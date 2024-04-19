
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ielts/chat/models/chat_user.dart';
import 'package:ielts/chat/screens/auth/login_screen.dart';
import 'package:ielts/chat/widgets/teacher_group_chat_widget.dart';
import 'package:ielts/services/auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

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
   YoutubePlayerController? _controller;
  String title = "";
  String discription1 = "";
  String discription2 = "";
  String enrollNow = "https://wa.me/+919612052091";
  String name = "";
  String price = "";
  String duration = "";
  String flag = "";
  bool showFullDescription1 = false;
  bool showFullDescription2 = false;
  String user = "";
  bool checkChat = false;

  @override
  void initState() {
    super.initState();
    fetchVideoIdFromFirestore();
    addGroup(widget.snap!.id);   // using for create new group if group is not available
    checkCurrentUserForGroupMember(); // checking current user for adding group member
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
    price = widget.snap!['price'];
    duration = widget.snap!['duration'];
    flag = widget.snap!['flag'];
    enrollNow = widget.snap!['enroll_now'];
    _controller = YoutubePlayerController(
      initialVideoId: widget.snap!['video_id'],
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    setState(() {});
    // } catch (e) {
    //   print('Error fetching video ID from Firestore: $e');
    // }
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
                      controller: _controller =
                          YoutubePlayerController(
                            initialVideoId: YoutubePlayer.convertUrlToId(widget.snap!['video_id']).toString(),
                            // showVideoProgressIndicator: true,
                    ),)
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
                        "2 Live Classes Per Week",
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

                      checkChat ?  GestureDetector(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>TeacherGroup(teacherId: widget.snap!.id)));

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
                            backgroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ) : GestureDetector(
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
                              backgroundColor: Colors.white.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ) ,
                      ],
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

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }
  void checkCurrentUserForGroupMember() {
    print('1');
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      checkGroupMember();
    }
  }

  void checkCurrentUserForAddMember() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      if(checkChat) {
        addMember(widget.snap!.id);
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PremiumScreen(),
          ),
        );
      }

    } else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen1(title: '')));
    }
  }

  Future<bool> checkGroupMember() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("Teacher")
        .doc(widget.snap!.id)
        .get();
    if(snapshot.exists){
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      List<String> membersID = List<String>.from(data!['membersID']);

      if (membersID.contains(auth.currentUser!.uid)) {
        setState(() {
          checkChat = true;
        });
        print('Member In');

      }else{
        setState(() {
          checkChat =false;
          print('member not in');
        });

      }
    }
    return false;

  }

  Future<void> addMember(teacherId) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid) // Replace with your document ID
        .get();


      List<ChatRoomMember> members = [
        ChatRoomMember(
          userId: document.id,
          name: document["firstName"],
          imageUrl: 'https://example.com/profile1.jpg',
          isAdmin: false,
        ),
      ];

      final GroupMessages message = GroupMessages(
        name: document['firstName'],
        msg: "1",
        read: '',
        type: Type.text,
        sent: time,
        fromid: auth.currentUser!.uid,
        toId: auth.currentUser!.uid,
      );
      List<Map<String, dynamic>> membersMap =
          members.map((member) => member.toMap()).toList();
      try {
        await FirebaseFirestore.instance.collection("Teacher").doc(teacherId).set({
          'membersID': FieldValue.arrayUnion(members.map((member) => member.userId).toList()),
          // List of user IDs
          'members': FieldValue.arrayUnion(membersMap),
          // List of members as maps
        },SetOptions(merge: true));

        await FirebaseFirestore.instance
            .collection("Teacher")
            .doc(teacherId)
            .collection("Chat")
            .doc(time).set(message.toJson()).then((value) => setState(() {
              checkChat = true;
            }));
        print('Document added to the new collection');
      } catch (e) {
        print('Error adding document: $e');
      }



    }

   Future<void> addGroup(teacherId) async {
     // Define the list of ChatRoomMember instances
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
           msg: "2",
           read: '',
           type: Type.text,
           sent: time,
           fromid: widget.snap!.id,
           toId: widget.snap!.id,
         );
         try {
           await firestore.collection("Teacher").doc(teacherId).set({
             'GroupId': teacherId,
             'GroupTitle': name,
             "GroupImage":"https://example.com/profile1.jpg",
             'membersID': members
                 .map((member) => member.userId)
                 .toList(), // List of user IDs
             'members': membersMap, // List of members as maps
           });

           await firestore
               .collection("Teacher")
               .doc(teacherId)
               .collection("Chat").doc(time).set(message.toJson());
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

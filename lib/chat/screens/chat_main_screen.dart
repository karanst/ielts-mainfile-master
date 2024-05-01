import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ielts/chat/models/chat_user.dart';
import 'package:ielts/chat/screens/profile_screen.dart';
import 'package:ielts/chat/widgets/chat_user_card.dart';
import 'package:ielts/chat/widgets/teacher_group_chat_widget.dart';
import 'package:ielts/main.dart';
import 'package:ielts/screens/headingcompletiondetails.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/screens/login_screen.dart';
import 'package:ielts/widgets/adsHelper.dart';

import '../../screens/adverting/advertining_screen.dart';
import '../api/apis.dart';
import '../models/message.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key});

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen>
    with TickerProviderStateMixin {
  //for storing all user
  List<ChatUser> _list = [];
  //for searing user
  FirebaseAuth auth = FirebaseAuth.instance;
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;
  final _adController = NativeAdController();
  TabController? _controller;
  int _selectedIndex = 0;

  DocumentSnapshot? teacherData;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo(context);

    _controller = TabController(length: 2, vsync: this);

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume'))
          APIs.updateActiveStatus(false);
        if (message.toString().contains('pause'))
          APIs.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _adController.ad = AdHelper.loadNativeAd(adController: _adController);

    return WillPopScope(
      onWillPop: () {
        if (_isSearching) {
          setState(() {
            _isSearching = !_isSearching;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          // bottomNavigationBar: _adController.ad != null &&
          //         _adController.adLoaded.isTrue
          //     ? SizedBox(
          //         height: 120,
          //         child: AdWidget(
          //             ad: _adController.ad!), // Create and load a new ad object
          //       )
          //     : null,

          //appbar
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.teal,
            elevation: 0, // Removes shadow
            // leading: IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     CupertinoIcons.home,
            //     color: Colors.black,
            //   ),
            // ),
            centerTitle: true,
            title: _isSearching
                ? TextField(
                    autofocus: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search name or email...',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    onChanged: (val) {
                      // Search logic
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                      }
                      setState(() {
                        _searchList;
                      });
                    },
                  )
                : Text(
                    'IELTS- YAN',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  if (!premium_user_google_play) {
                    ads.showInterstitialAd();
                    // AdHelper.initAds();
                    // AdHelper.showInterstitialAd();
                  }
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (!premium_user_google_play) {
                    ads.showInterstitialAd();

                    // AdHelper.showInterstitialAd();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          user: APIs.me,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ),
            ],
            bottom: TabBar(
              // padding: EdgeInsets.all(10),
              labelColor: Colors.black,
              indicatorColor: Colors.white,
              indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Chat'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Group'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                child: StreamBuilder(
                  stream: APIs.getAllUsers(),
                  builder: (BuildContext context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        print(data);
                        _list = _list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .where(
                                    (user) => user.uid != auth.currentUser!.uid)
                                .toList() ??
                            [];

                        print('-----------------------------');
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            itemCount: _isSearching
                                ? _searchList.length
                                : _list.length,
                            physics: BouncingScrollPhysics(),
                            // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                            itemBuilder: (context, index) {
                              return ChatUserCard(
                                user: _isSearching
                                    ? _searchList[index]
                                    : _list[index],
                              );
                            },
                          );
                        } else {
                          return Center(child: Text('No connection found'));
                        }
                    }
                  },
                ),
              ),
              //for chat view,
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Teacher')
                      .orderBy('Timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          // Retrieve the current document data
                          final doc = snapshot.data!.docs[i];
                          // Get the list of members' IDs
                          List<String> membersID =
                              List<String>.from(doc['membersID']);
                          List<Map<String, dynamic>> recentChat =
                              List<Map<String, dynamic>>.from(
                                  doc['RecentChat']);

                          // Check if the current user ID is in the members' IDs list
                          bool isMember = false;
                          bool isAdmin = false;
                          if (auth.currentUser!.uid.isNotEmpty) {
                            isMember =
                                membersID.contains(auth.currentUser!.uid);
                          }
                          if (auth.currentUser!.uid == doc['GroupId']) {
                            isAdmin = true;
                          }

                          print('this is admin details $isAdmin ${auth.currentUser!.uid} and ${doc['GroupId']}');

                          String recentChatMessage = '';
                          String recentLastChatId = '';
                          int recentChatLength = 0;
                          if (recentChat.isNotEmpty) {
                            recentChatMessage =
                                recentChat.last['message'] ?? '';
                            recentChatLength = recentChat.length;
                            recentLastChatId = recentChat.last['id'] ?? '';
                          }

                          return ListTile(
                              // User profile picture
                              leading: InkWell(
                                onTap: () {},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // Adjust the corner radius as needed
                                  child: CachedNetworkImage(
                                    width: 55.0, // Adjust width as needed
                                    height: 55.0, // Adjust height as needed
                                    imageUrl: doc['GroupImage'].toString(),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      child: Icon(CupertinoIcons.person),
                                    ),
                                  ),
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (recentChat.isNotEmpty)
                                    Text(recentChatMessage, maxLines: 1),
                                  if (recentLastChatId !=
                                          auth.currentUser!.uid &&
                                      recentChat.isNotEmpty)
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                      child: Center(
                                        child: Text(recentChatLength.toString(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                ],
                              ),
                              title: Text(doc['GroupTitle'].toString()),
                              trailing: isAdmin
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        if (recentLastChatId !=
                                            auth.currentUser!.uid) {
                                          setRecentList(doc.id);
                                        }

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TeacherGroup(
                                                        teacherId: snapshot
                                                            .data!
                                                            .docs[i]
                                                            .id)));
                                      },
                                      child: Text("Chat Now"),
                                    )
                                  : isMember
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            if (recentLastChatId !=
                                                auth.currentUser!.uid) {
                                              setRecentList(doc.id);
                                            }

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TeacherGroup(
                                                            teacherId: snapshot
                                                                .data!
                                                                .docs[i]
                                                                .id)));
                                          },
                                          child: Text("Chat Now"),
                                        )
                                      : ElevatedButton(
                                          onPressed: () async {
                                            if (auth
                                                .currentUser!.uid.isNotEmpty) {
                                              await FirebaseFirestore.instance
                                                  .collection("TeacherData")
                                                  .snapshots()
                                                  .forEach((element) {
                                                print(
                                                    'this is elemet ${element.docs[i]['TeacherId']} ${doc['GroupId']}');
                                                if (element.docs[i]['TeacherId']
                                                        .toString() ==
                                                    doc['GroupId']) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              AdvertisingScreen(
                                                                snap: element
                                                                    .docs[i],
                                                              )));
                                                }
                                              });

                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (_) =>
                                              //             AdvertisingScreen(snap: snapshot.data!.docs[i],)));
                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherGroup(teacherId: snapshot.data!.docs[i].id)));
                                              // addMember(snapshot.data!.docs[i].id);
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen1(
                                                              title: 'Login')));
                                            }
                                            setState(() {});
                                            // Handle join action (e.g., adding the current user to the group)
                                            // Add your join group code here
                                          },
                                          child: Text("Join Now"),
                                        ));
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      ); // Handle errors
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      ); // Display your UI with the data
                    }
                  },
                ),
              ),
              //for group view,
            ],
          ),
        ),
      ),
    );
  }

  setRecentList(teacherId) async {
    await FirebaseFirestore.instance
        .collection("Teacher")
        .doc(teacherId)
        .update({"RecentChat": []});
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
        name: document["name"],
        imageUrl: 'https://example.com/profile1.jpg',
        isAdmin: false,
      ),
    ];

    final GroupMessages message = GroupMessages(
      name: document['name'],
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
      await FirebaseFirestore.instance
          .collection("Teacher")
          .doc(teacherId)
          .set({
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
          .set(message.toJson());
      print('Document added to the new collection');
    } catch (e) {
      print('Error adding document: $e');
    }
  }
}

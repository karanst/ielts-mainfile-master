import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ielts/screens/home_screen.dart';
import 'package:ielts/utils/app_constants.dart';
import 'package:ielts/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatefulWidget {
  final String userId;

  MenuPage({required this.userId});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late String userId;

  _launchURL() async {
    const url = 'mailto:singh.nikhil999@gmail.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final List<MenuItem> options = [
    MenuItem(Icons.home, 'Home', RoutePaths.root),
    MenuItem(Icons.library_books, 'Vocabulary', RoutePaths.vocabulary),
    // MenuItem(Icons.speaker_notes, 'Blog', RoutePaths.blog),
    MenuItem(Icons.people, 'Quiz', RoutePaths.quiz),
    MenuItem(Icons.forum, 'Discussions', RoutePaths.chats),
  ];

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    print('userId: $userId');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, RoutePaths.home);
        return Future.value(true);
      },
      child: Scaffold(
        body: GestureDetector(
          onPanUpdate: (details) {},
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(62),
              left: ScreenUtil().setWidth(32),
              bottom: ScreenUtil().setHeight(8),
              right: MediaQuery.of(context).size.width / 2.9,
            ),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: StreamBuilder(
                    stream: userId.isNotEmpty
                        ? FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .snapshots()
                        : null, // Added a check for userId.isNotEmpty
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasData && snapshot.data.exists) {
                        print('snapshot.data(): ${snapshot.data['firstName']}');
                        User user = User(
                          firstName: snapshot.data['firstName'] ?? "",
                          photoUrl: snapshot.data['userImage'] ?? "",
                          // firstName:  "",
                          // photoUrl:  "",
                        );
                        return Row(
                          children: <Widget>[
                            CircularImage(
                              CachedNetworkImageProvider(user.photoUrl ?? ''),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(15),
                            ),
                            Text(
                              user.firstName ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(20),
                              ),
                            ),
                          ],
                        );
                      } else {
                        User dummyUser = User(
                          firstName: 'Dummy User',
                          photoUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTP6HBlxRaCn7CViHiZrhpx1Sx4GHM-dafYZZjW0eizMFidSQRS&usqp=CAU',
                        );

                        return Row(
                          children: <Widget>[
                            CircularImage(
                              CachedNetworkImageProvider(
                                  dummyUser.photoUrl ?? ''),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(15),
                            ),
                            Text(
                              dummyUser.firstName ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(20),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Spacer(),
                Column(
                  children: options.map((item) {
                    return Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, item.routeName);
                        },
                        leading: Icon(
                          item.icon,
                          color: Colors.white,
                          size: ScreenUtil().setSp(20),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (premium_user == true)
                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
                    child: ListTile(
                      onTap: () =>
                          Navigator.pushNamed(context, RoutePaths.premium),
                      leading: Icon(
                        Icons.all_inclusive,
                        color: Colors.white,
                        size: ScreenUtil().setSp(20),
                      ),
                      title: Text('Premium',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.white)),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePaths.settings);
                    },
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: ScreenUtil().setSp(20),
                    ),
                    title: Text('Settings',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;
  String routeName;

  MenuItem(this.icon, this.title, this.routeName);
}

class User {
  String? firstName;
  String? photoUrl;

  User({
    this.firstName,
    this.photoUrl,
  });
}

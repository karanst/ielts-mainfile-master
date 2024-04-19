import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Slider2 extends StatefulWidget {
  const Slider2({Key? key});

  @override
  State<Slider2> createState() => _Slider3State();
}

class _Slider3State extends State<Slider2> {
  late YoutubePlayerController _controller;
  String title = "";
  String discription1 = "";
  String discription2 = "";
  String enrollNow = "";
  String name = "";
  String price = "";
  String duration = "";
  String flag = "";
  bool showFullDescription1 = false;
  bool showFullDescription2 = false;

  @override
  void initState() {
    super.initState();
    fetchVideoDataFromFirestore();
  }

  void fetchVideoDataFromFirestore() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('youtube_videos')
          .doc('QJSLsE1x2m6pJkF6DLSy') // Replace with your document ID
          .get();
      String videoId = document['video_id'];
      title = document['title'];
      discription1 = document['discription_1'];
      discription2 = document['discription_2'];
      name = document['name'];
      price = document['price'];
      duration = document['duration'];
      flag = document['flag'];
      enrollNow = document['enroll_now'];

      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      setState(() {});
    } catch (e) {
      print('Error fetching video data from Firestore: $e');
    }
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
                        GestureDetector(
                          onTap: () {
                            _showPopup(context);
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
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     _showPopup(context);
                        //   },
                        //   child: ElevatedButton(
                        //     onPressed: null,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //         vertical: 12,
                        //         horizontal: 20,
                        //       ),
                        //       child: Text(
                        //         "Book a Trial Lesson",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //     style: ElevatedButton.styleFrom(
                        //       primary: Colors.white.withOpacity(0.4),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
    _controller.dispose();
    super.dispose();
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Coming Soon"),
          content: Text(
              "This feature will be available on the 25th of this month.\n\nFor further details"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancle",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                const String url =
                    "https://wa.me/+919612052091"; // Example WhatsApp contact link
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  Fluttertoast.showToast(
                    msg: "Cannot launch URL",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 3,
                ),
                child: Text(
                  "For More",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.teal), // Border color
                ),
              ),
            ),
          ],
        );
      },
    );
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

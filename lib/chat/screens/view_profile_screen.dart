import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ielts/chat/halper/my_date_util.dart';
import 'package:ielts/chat/models/chat_user.dart';
import 'package:ielts/main.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../halper/dialog.dart';
import '../main.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: AppBar(
            title: Text(widget.user.name),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Joined On ',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              // Text(
              //     MyDateUtil.getLastMessageTime(
              //       context: context,
              //       time: widget.user.createdAt == null || widget.user.createdAt == '' ?
              //           ''
              //       : widget.user.createdAt,
              //       showYear: true,
              //     ),
              //     style: const TextStyle(color: Colors.black54, fontSize: 16)),
            ],
          ),
          //body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * .03),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.height * .2,
                      height: MediaQuery.of(context).size.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  // for adding some space
                  SizedBox(height: MediaQuery.of(context).size.height * .03),

                  // user email label
                  Text(widget.user.email,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 16)),
                  SizedBox(height: MediaQuery.of(context).size.height * .01),

                  // user email label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'About  ',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Text(widget.user.about,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

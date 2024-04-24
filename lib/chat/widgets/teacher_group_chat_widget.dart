import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ielts/chat/widgets/group_info.dart';
import 'package:ielts/services/api.dart';
import 'package:ielts/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../api/apis.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../models/message_card.dart';
import '../screens/view_profile_screen.dart';

class TeacherGroup extends StatefulWidget {
  const TeacherGroup({Key? key, required this.teacherId}) : super(key: key);
  final String teacherId;
  @override
  State<TeacherGroup> createState() => _TeacherGroupState();
}

class _TeacherGroupState extends State<TeacherGroup> {
  List<Messages> _list = [];

  final _textController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  bool _showEmogi = false, _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmogi) {
              setState(() {
                _showEmogi = !_showEmogi;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: _appBar(),
              ),
              backgroundColor: Colors.blue.shade100,
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Teacher')
                          .doc(widget.teacherId)
                          .collection("Chat")
                          .orderBy('sent', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            _list = data
                                    ?.map((e) => Messages.fromJson(e.data()))
                                    .toList() ??
                                [];
                            print(_list);

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  reverse: true,
                                  itemCount: _list.length,
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          .01),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return MessageCaed(message: _list[index]);
                                  });
                            } else {
                              return const Center(
                                child: Text('H Hii! 👋',
                                    style: TextStyle(fontSize: 20)),
                              );
                            }
                        }
                      },
                    ),
                  ),
                  if (_isUploading == true)
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))),

                  _chatInput(),


                ],
              )),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => GroupInfo(teacherId:widget.teacherId)));
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Teacher").doc(widget.teacherId).snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data;


            return
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.height * .05,
                      height: MediaQuery.of(context).size.height * .05,
                      fit: BoxFit.cover,
                      imageUrl:data!["GroupImage"],
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data!["GroupTitle"],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      // Text(
                      //   list.isNotEmpty
                      //       ? list[0].isOnline
                      //       ? 'Online'
                      //       : 'Last seen recently'
                      //       : 'Last seen recently',
                      //   style:
                      //   const TextStyle(fontSize: 13, color: Colors.black54),
                      // ),
                    ],
                  )
                ],
              );
          },
        ));
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .01,
          horizontal: MediaQuery.of(context).size.width * 0.03),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showEmogi = !_showEmogi;
                      });
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type Something....',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker(); // Pick an image
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 80);

                      // ignore: unused_local_variable
                      for (var i in images) {
                        setState(() {
                          _isUploading = true;
                        });
                        // if (images.isNotEmpty) {
                        log('Image Path: ${i.path}');

                        // APIs.sendChatImage(widget.user, File(images.path));
                        // APIs.updateProfilePicture(File(_image!));
                        // for hiding bottom sheet
                        APIs.sendGroupChatImage(
                            teacherId: widget.teacherId,
                            file: File(i.path),
                            token: auth.currentUser!.refreshToken);

                        setState(() {
                          _isUploading = false;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      print("hell");
                      final ImagePicker picker = ImagePicker(); // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      print("--------------------------------------------------------------------------------$image");
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _isUploading = true;
                        });
                        APIs.sendGroupChatImage(
                            teacherId: widget.teacherId,
                            file: File(image.path),
                            token: auth.currentUser!.refreshToken).then((value){
                          setState(() {
                            _isUploading = false;
                            print("----------------------------------------------------------------------$_isUploading");
                          });
                        });
                        setState(() {

                        });
                        // APIs.updateProfilePicture(File(_image!));
                        // for hiding bottom sheet


                      }
                    },
                    icon: Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * .02,
                  ),
                ],
              ),
            ),
          ),

          //send message botton

          MaterialButton(
            shape: CircleBorder(),
            color: Colors.green,
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendGroupMessage(
                    msg: _textController.text,
                    type: Type.text,
                    teacherId: widget.teacherId,
                    token: auth.currentUser!.refreshToken);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

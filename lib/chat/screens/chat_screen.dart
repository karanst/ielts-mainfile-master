import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ielts/chat/models/chat_user.dart';
import 'package:ielts/chat/models/message_card.dart';
import 'package:ielts/chat/screens/view_profile_screen.dart';
import 'package:ielts/main.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Messages> _list = [];

  final _textController = TextEditingController();

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
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();

                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => Messages.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  reverse: true,
                                  itemCount: _list.length,
                                  padding:
                                      EdgeInsets.only(top: mq.height * .01),
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
                  if (_isUploading)
                    Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ))),

                  _chatInput(),

                  //show imgogi
                  if (_showEmogi)
                    SizedBox(
                      height: mq.height * .35,
                      // child: EmojiPicker(
                      //   textEditingController: _textController,
                      //   // config: Config(
                      //   //   bgColor: const Color.fromARGB(255, 234, 248, 255),
                      //   //   columns: 8,
                      //   //   emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      //   // ),
                      // ),
                    )
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
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserIngo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

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
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    width: mq.height * .05,
                    height: mq.height * .05,
                    fit: BoxFit.cover,
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
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
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : 'Last seen recently'
                          : 'Last seen recently',
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
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
          vertical: mq.height * .01, horizontal: mq.width * 0.03),
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
                        hintText: 'Type Someting....',
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

                        APIs.sendChatImage(widget.user, File(i.path));
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
                      final ImagePicker picker = ImagePicker(); // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        // log('Image Path: ${image.path}');
                        setState(() {
                          _isUploading = true;
                        });
                        APIs.sendChatImage(widget.user, File(image.path));
                        // APIs.updateProfilePicture(File(_image!));
                        // for hiding bottom sheet

                        setState(() {
                          _isUploading = true;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.camera,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(
                    width: mq.width * .02,
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
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
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

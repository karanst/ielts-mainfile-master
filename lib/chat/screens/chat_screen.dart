import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ielts/chat/halper/voice_record.dart';
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
String toId= '';
  bool _showEmogi = false, _isUploading = false;

  void openVoiceRecord() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => VoiceRecord(
          user: widget.user,
          // recordingCallback: (media) {
          //   // sendAudioMessage(
          //   //     media: media,
          //   //     mode: _chatDetailController.actionMode.value,
          //   //     room: _chatDetailController.chatRoom.value!);
          // },
        ));
  }
  // Future<bool> sendAudioMessage(
  //     {required Media media,
  //       required ChatMessageActionMode mode,
  //       required ChatRoomModel room}) async {
  //   bool status = true;
  //
  //   String localMessageId = randomId();
  //   String? repliedOnMessage = selectedMessage.value == null
  //       ? null
  //       : jsonEncode(selectedMessage.value!.toJson()).encrypted();
  //
  //   // store audio in local storage
  //   File mainFile = await FileManager.saveChatMediaToDirectory(
  //       media, localMessageId, false, chatRoom.value!.id);
  //
  //   ChatMessageModel currentMessageModel = ChatMessageModel();
  //
  //   var content = {
  //     'messageType': messageTypeId(MessageContentType.audio),
  //   };
  //   currentMessageModel.localMessageId = localMessageId;
  //   currentMessageModel.roomId = room.id;
  //   currentMessageModel.isEncrypted = AppConfigConstants.enableEncryption;
  //   currentMessageModel.chatVersion = AppConfigConstants.chatVersion;
  //   currentMessageModel.sender = _userProfileManager.user.value!;
  //
  //   // currentMessageModel.messageTime = LocalizationString.justNow;
  //   currentMessageModel.userName = LocalizationString.you;
  //   currentMessageModel.senderId = _userProfileManager.user.value!.id;
  //   currentMessageModel.messageType = messageTypeId(
  //       mode == ChatMessageActionMode.reply
  //           ? MessageContentType.reply
  //           : MessageContentType.audio);
  //   currentMessageModel.createdAt =
  //       (DateTime.now().millisecondsSinceEpoch / 1000).round();
  //   currentMessageModel.messageContent = json.encode(content).encrypted();
  //   // currentMessageModel.media = media;
  //   currentMessageModel.repliedOnMessageContent = repliedOnMessage;
  //
  //   addNewMessage(message: currentMessageModel, roomId: room.id);
  //
  //   getIt<DBManager>().saveMessage(chatMessages: [currentMessageModel]);
  //   update();
  //
  //   // upload audio and send message
  //
  //   uploadMedia(
  //       messageId: localMessageId,
  //       media: media,
  //       mainFile: mainFile,
  //       callback: (uploadedMedia) {
  //         var content = {
  //           'messageType': messageTypeId(MessageContentType.audio),
  //           'audio': uploadedMedia.audio,
  //         };
  //
  //         var message = {
  //           'userId': _userProfileManager.user.value!.id,
  //           'localMessageId': localMessageId,
  //           'is_encrypted': AppConfigConstants.enableEncryption,
  //           'chat_version': AppConfigConstants.chatVersion,
  //           'messageType': messageTypeId(mode == ChatMessageActionMode.reply
  //               ? MessageContentType.reply
  //               : MessageContentType.audio),
  //           'message': json.encode(content).encrypted(),
  //           'room': room.id,
  //           'created_by': _userProfileManager.user.value!.id,
  //           'created_at': currentMessageModel.createdAt,
  //           'replied_on_message': repliedOnMessage,
  //         };
  //
  //         // send message to socket
  //         status =
  //             getIt<SocketManager>().emit(SocketConstants.sendMessage, message);
  //
  //         // update in cache message
  //
  //         currentMessageModel.messageContent = json.encode(content).encrypted();
  //
  //         // update message in local database
  //         getIt<DBManager>().updateMessageContent(
  //             roomId: room.id,
  //             localMessageId: currentMessageModel.localMessageId.toString(),
  //             content: json.encode(content).encrypted());
  //       });
  //
  //   setReplyMessage(message: null);
  //   return status;
  // }
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
                              if(toId ==''){
                                toId =_list[0].told;
                                print('---->>> ${toId}');
                              }

                              return ListView.builder(
                                  reverse: true,
                                  itemCount: _list.length,
                                  padding:
                                      EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: (){

                                      },
                                        child: MessageCaed(message: _list[index]));
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
                      height: MediaQuery.of(context).size.height * .35,
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
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .1),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.height * .05,
                    height: MediaQuery.of(context).size.height * .05,
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
          vertical: MediaQuery.of(context).size.height * .01, horizontal: MediaQuery.of(context).size.width * 0.03),
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
                      openVoiceRecord();
                      // setState(() {
                      //   _showEmogi = !_showEmogi;
                      // });
                    },
                    icon: Icon(
                      Icons.mic,
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
                          await picker.pickMultiImage(imageQuality: 60);

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
                        updateTimeStamp(toId);

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
                if (_list.isEmpty) {

                  print(widget.user);
                  print('------------------------------------------');
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                  updateTimeStamp(toId);
                } else {
                  //simply send message
                  print('this is message ${widget.user.poshToken}');
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                updateTimeStamp(toId);

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
  updateTimeStamp(toId) async{
    print(toId);
    DateTime dateTime = DateTime.now();
    Timestamp specificTimeStamp = Timestamp.fromDate(dateTime);
   await FirebaseFirestore.instance.collection('users').doc(toId).update({
      'timeStamp':specificTimeStamp
    });
   setState(() {

   });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ielts/chat/api/apis.dart';
import 'package:ielts/chat/halper/my_date_util.dart';
import 'package:ielts/main.dart';

import '../halper/dialog.dart';
import '../main.dart';
import 'message.dart';

class MessageCaed extends StatefulWidget {
  MessageCaed({super.key, required this.message});
  final Messages message;

  @override
  State<MessageCaed> createState() => _MessageCaedState();
}

class _MessageCaedState extends State<MessageCaed> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromid;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  //sender or nother user message
  Widget _blueMessage() {
// update lst read message
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue),
                    color: Color.fromARGB(255, 224, 186, 186),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                margin:
                    EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .04, vertical: .01),
                child: Padding(
                  padding: EdgeInsets.all(widget.message.type == Type.image
                      ? 10
                  // MediaQuery.of(context).size.width * .01
                      : MediaQuery.of(context).size.width * .04),
                  child: widget.message.type == Type.text
                      ? Column(
                        children: [
                          Text(
                              widget.message.msg,
                              style: TextStyle(fontSize: 15, color: Colors.black87),
                            ),
                          if(auth.currentUser!.uid ==widget.message.fromid )
                            Text("Me"),
                          if(auth.currentUser!.uid !=widget.message.fromid)
                           Text(widget.message.name)
                        ],
                      )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                              // width: MediaQuery.of(context).size.height * .05,
                              // height: MediaQuery.of(context).size.height * .05,

                              imageUrl: widget.message.msg,
                              placeholder: (context, url) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                              errorWidget: (context, url, error) => Icon(
                                    Icons.image,
                                    size: 70,
                                  )),
                        ),

                ),

              ),


            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            MyDateUtil.getFormatedTime(
                context: context, time: widget.message.sent),
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
        // SizedBox(
        //   width: MediaQuery.of(context).size.width * .02,
        // )
      ],
    );
  }
  //self message

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            //double tick blue icon
            SizedBox(
              width: MediaQuery.of(context).size.width * .04,
            ),
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),

            //for adding some space
            // SizedBox(width: 2),
            // red line
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * .04,
            // ),
            Text(
              MyDateUtil.getFormatedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                color: Color.fromARGB(255, 166, 214, 146),
                borderRadius: BorderRadius.only(
                    // bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            margin:
                EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .04, vertical: .01),
            child: Padding(
              padding: EdgeInsets.all(widget.message.type == Type.image
                  ? MediaQuery.of(context).size.width * .01
                  : MediaQuery.of(context).size.width * .04),
              child: widget.message.type == Type.text
                  ? Column(
                    children: [
                      Text(
                          widget.message.msg,
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      Text("me")
                    ],
                  )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                          // width: MediaQuery.of(context).size.height * .05,
                          // height: MediaQuery.of(context).size.height * .05,

                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          errorWidget: (context, url, error) => Icon(
                                Icons.image,
                                size: 70,
                              )),
                    ),
            ),
          ),
        ),

        // SizedBox(
        //   width: MediaQuery.of(context).size.width * .02,
        // )
      ],
    );
  }

  // bottom sheet for adding message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .015, horizontal: MediaQuery.of(context).size.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
              ),
              //pick profile picture label

              //for adding some space
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              // copy text
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: Icon(
                        Icons.copy_all_outlined,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);
                          Dialogs.showSnackbar(context, 'Text Copied');
                        });
                      },
                    )
                  : _OptionItem(
                      icon: Icon(
                        Icons.download,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Save Image',
                      onTap: () {},
                    ),
              // Divider(

              //   color: Colors.black54,
              //   endIndent: mq.width * .04,
              //   indent: MediaQuery.of(context).size.height * .04,
              // ),

              //edit test
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.green,
                    size: 26,
                  ),
                  name: 'Edit Message',
                  onTap: () {},
                ),
              // Divider(
              //   color: Colors.black54,
              //   endIndent: MediaQuery.of(context).size.width * .04,
              //   indent: MediaQuery.of(context).size.height * .04,
              // ),
              // delete option
              if (isMe)
                _OptionItem(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 26,
                  ),
                  name: 'Delete Message',
                  onTap: () async {
                    APIs.deleteMessage(widget.message).then((value) {
                      Navigator.pop(context);
                    });
                  },
                ),
              //sent option
              _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.teal,
                  size: 26,
                ),
                name:
                    'Sent At: ${MyDateUtil.getFormatedTime(context: context, time: widget.message.sent)}',
                onTap: () {},
              ),
              //read option
              _OptionItem(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Colors.orange,
                  size: 26,
                ),
                name: widget.message.read.isEmpty
                    ? 'Read At: Not seen yet'
                    : 'Read At: ${MyDateUtil.getFormatedTime(context: context, time: widget.message.read)}',
                onTap: () {},
              ),
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;

  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * .05,
          top: MediaQuery.of(context).size.height * 0.015,
          bottom: MediaQuery.of(context).size.height * 0.025,
        ),
        child: Row(
          children: [
            icon,
            Flexible(child: Text('   $name')),
          ],
        ),
      ),
    );
  }
}

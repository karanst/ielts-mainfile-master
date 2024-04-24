import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ielts/chat/models/chat_user.dart';
import 'package:ielts/chat/screens/home_screen.dart';

import '../../utils/notification_service.dart';
import '../models/message.dart';

@pragma('vm:entry-point')
class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
//for messaing firebase message
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);

        // await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> getFirebaseMessagingToken(context) async {
    print(
        '1111111111111111111111111111111111111111111111111111111111111111111111');

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.poshToken = t;
        log('Push Token: $t');
      }
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        var data = message.notification!;
        if (message.notification != null) {
          var title = data.title.toString();
          var body = data.body.toString();
          var type = message.data['type'] ?? '';
          var id = '';
          id = message.data['type_id'] ?? '';

          generateSimpleNotication(title, body, type, id);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreens()));
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('222222222222222222222222222222222222222222222222222222');

        // Handle the received message when the app is opened from a terminated state
        if (message.notification != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreens()));
        }
      });
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message == null) return;
        var notificationData = message.data;


        if(notificationData.isNotEmpty) {

Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreens()));
        }

      });
    });
  }

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg, String name) async {
    print('notification sent ');
    try {
      final body = {
        "to": chatUser.poshToken,
        "notification": {
          "title": name ?? "test", //our name should be send
          "body": msg,
          "android_channel_id": "ieltsyan"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };
      print('---->$body');

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAYYkGFX8:APA91bEUfd_H-QV08dJ6Qa3tXFUPi1Svpyd7Wyvso5ePTt-KYa8p9DYH7lmghDPZd7TvOGtAaoB57fs6BUP2d83ZWqdwHD1QMxQkhLLL_3DEZb8DwO7_cJEjRvoxTh5Hzbw91Dy1qLIt'
            // 'AAAAQ0Bf7ZA:APA91bGd5IN5v43yedFDo86WiSuyTERjmlr4tyekbw_YW6JrdLFblZcbHdgjDmogWLJ7VD65KGgVbETS0Px7LnKk8NdAz4Z-AsHRp9WoVfArA5cNpfMKcjh_MQI-z96XQk5oIDUwx8D1'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static Future<void> sendGroupMessage(
      {required String msg,
      required Type type,
      required String teacherId,
      required token}) async {
    DateTime dateTime = DateTime.now();
    Timestamp specificTimeStamp = Timestamp.fromDate(dateTime);

    final time = DateTime.now().microsecondsSinceEpoch.toString();
    List<RecentChat> recentChats = [
      RecentChat(
          id: auth.currentUser!.uid, // In Add group id is teacher Id
          message: msg),
    ];
    List<Map<String, dynamic>> recentChatData =
        recentChats.map((recentChat) => recentChat.toMap()).toList();
    // message to send
    final GroupMessages message = GroupMessages(
      name: '',
      msg: msg,
      read: '',
      type: type,
      sent: time,
      fromid: auth.currentUser!.uid,
      toId: auth.currentUser!.uid,
    );
    await FirebaseFirestore.instance.collection("Teacher").doc(teacherId).set({
      'RecentChat': FieldValue.arrayUnion(recentChatData),
    }, SetOptions(merge: true));
    final ref = FirebaseFirestore.instance
        .collection('Teacher')
        .doc(teacherId)
        .collection('Chat');
    await ref.doc(time).set(message.toJson());

    await FirebaseFirestore.instance
        .collection("Teacher")
        .doc(teacherId)
        .update({
      "Timestamp": specificTimeStamp,
    });
  }

  static Future<void> sendGroupPushNotification(
      String poshToken, String msg) async {
    print('notification sent ');
    try {
      final body = {
        "to": poshToken,
        "notification": {
          "title": me.name ?? "test", //our name should be send
          "body": msg,
          "android_channel_id": "ieltsyan"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };
      print('---->$body');

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAYYkGFX8:APA91bEUfd_H-QV08dJ6Qa3tXFUPi1Svpyd7Wyvso5ePTt-KYa8p9DYH7lmghDPZd7TvOGtAaoB57fs6BUP2d83ZWqdwHD1QMxQkhLLL_3DEZb8DwO7_cJEjRvoxTh5Hzbw91Dy1qLIt'
            // 'AAAAQ0Bf7ZA:APA91bGd5IN5v43yedFDo86WiSuyTERjmlr4tyekbw_YW6JrdLFblZcbHdgjDmogWLJ7VD65KGgVbETS0Px7LnKk8NdAz4Z-AsHRp9WoVfArA5cNpfMKcjh_MQI-z96XQk5oIDUwx8D1'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //for storinf self information
  static ChatUser me = ChatUser(
      uid: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: false,
      lastActive: '',
      poshToken: '');
  // for checking user exist or not

  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // for checking  self user exist or not

  static User get user => auth.currentUser!;
// for creting a new user

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      poshToken: '',
      name: user.displayName.toString(),
      about: 'Hay welcome here',
      createdAt: time,
      lastActive: time,
      isOnline: false,
      uid: user.uid,
      email: user.email.toString(),
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

//gatting all user from firestore databse
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return firestore
        .collection('users')
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

// for updating user informatio

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }
  //update profile picture

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    // Await the completion of putFile and retrieve the download URL
    final uploadTask =
        ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    final uploadTaskSnapshot = await uploadTask.whenComplete(() {});
    me.image = await uploadTaskSnapshot.ref.getDownloadURL();

    // Update Firestore with the new image URL
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  //////  ******* chat screen realeated  **** ////////
//gatting all messges from firestore databse
  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessages(
      String teacherId) {
    return firestore
        .collection('Teacher')
        .doc(teacherId)
        .collection("chat")
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // chat {colection_id(doc)}
//for sending message

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    /// message sending time
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    // message to send
    final Messages message = Messages(
      name: chatUser.name,
      msg: msg,
      read: '',
      told: chatUser.uid,
      type: type,
      sent: time,
      fromid: user.uid,
      fromId: user.uid,
      toId: chatUser.uid,
    );
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.uid)}/messages/');

    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : type == Type.image ? 'image' : 'audio', chatUser.name));
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.uid)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }
  //update read status

  static Future<void> updateMessageReadStatus(Messages message) async {
    firestore
        .collection('chats/${getConversationID(message.fromid)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  //get only last message a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.uid)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chatimage

  // for getting spesific user information

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserIngo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.uid)
        .snapshots();
  }
//update  online for lst cyive status of user

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().microsecondsSinceEpoch.toString(),
      'posh_token': me.poshToken,
    });
  }

  //send chat image

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    // final ext = file.path.split('.').last;
    Reference db = FirebaseStorage.instance
        .ref('images/${getConversationID(chatUser.uid)}/${DateTime.now().microsecondsSinceEpoch}');
    await db.putFile(File(file.path));
    // final ref = storage.ref().child(
    //     'images/${getConversationID(chatUser.uid)}/${DateTime.now().microsecondsSinceEpoch}.$ext');
    // ref
    //     .putFile(file, SettableMetadata(contentType: '/image/$ext'))
    //     .then((p0) {});
    print('this is image is sending $db');
    //updating image
    final ImageUrl = await db.getDownloadURL();

    await sendMessage(chatUser, ImageUrl, Type.image);
  }

  static Future<void> sendAudioMessage(ChatUser chatUser, File file) async {

    Reference db = FirebaseStorage.instance
        .ref('audio/${getConversationID(chatUser.uid)}/${DateTime.now().microsecondsSinceEpoch}');
    await db.putFile(File(file.path));

    print('this is audio is sending $db');

    //updating image
    final audioUrl = await db.getDownloadURL();

    print('this is audio is sending $audioUrl');

    await sendMessage(chatUser, audioUrl, Type.audio);
  }

  static Future<void> sendGroupChatImage(
      {required String teacherId, required File file, required token}) async {
    print("helooooooooooooooooooooooooo");
    Reference db = FirebaseStorage.instance
        .ref("images/${teacherId}/${DateTime.now().microsecondsSinceEpoch}");
    await db.putFile(File(file.path));

    final ImageUrl = await db.getDownloadURL();
    print("----------------------------------------------------${ImageUrl}");

    await sendGroupMessage(
        token: token, msg: ImageUrl, type: Type.image, teacherId: teacherId);
  }

  //delete messag
  static Future<void> deleteMessage(Messages message) async {
    await firestore
        .collection('chats/${getConversationID(message.told)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
    await storage.refFromURL(message.msg).delete();
  }
}

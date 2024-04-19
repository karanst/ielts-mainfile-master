import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:ielts/chat/models/chat_user.dart';

import '../../utils/notification_service.dart';
import '../models/message.dart';

@pragma('vm:entry-point')
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  return Future<void>.value();
}

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
//for messaing firebase message
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.poshToken = t;
        log('Push Token: $t');
      }
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        var data = message.notification!;
        if (message.notification != null) {
          var title = data.title.toString();
          var body = data.body.toString();

          var type = message.data['type'] ?? '';
          var id = '';
          id = message.data['type_id'] ?? '';
          generateSimpleNotication(title, body, type, id);
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
    });

    // for handling foreground messages
  }

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    print('notification sent ');
    try {
      final body = {
        "to": chatUser.poshToken,
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
  static Future<void> sendGroupMessage(
      {required String msg,required Type type, required String teacherId,required token}) async {
    /// message sending time
    final time = DateTime.now().microsecondsSinceEpoch.toString();

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
    final ref = FirebaseFirestore.instance
        .collection('Teacher').doc(teacherId).collection('Chat');
    await ref.doc(time).set(message.toJson());
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
      id: user.uid,
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

  static Future<void> getSelfInfo() async {
    print('working');
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);

        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

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
      id: user.uid,
      email: user.email.toString(),
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

//gatting all user from firestore databse
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
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
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessages(
      String teacherId) {
    return firestore
        .collection('Teacher').doc(teacherId).collection("chat")
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
      name: '',
      msg: msg,
      read: '',
      told: chatUser.id,
      type: type,
      sent: time,
      fromid: user.uid,
      fromId: user.uid,
      toId: chatUser.id,
    );
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }


  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('users')
        .doc(chatUser.id)
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
        .collection('chats/${getConversationID(user.id)}/messages/')
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
        .where('id', isEqualTo: chatUser.id)
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
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().microsecondsSinceEpoch}.$ext');
    ref
        .putFile(file, SettableMetadata(contentType: '/image/$ext'))
        .then((p0) {});

    //updating image
    final ImageUrl = await ref.getDownloadURL();

    await sendMessage(chatUser, ImageUrl, Type.image);
  }
  static Future<void> sendGroupChatImage({ required String teacherId, required File file, required token}) async {
    print("helooooooooooooooooooooooooo");
    Reference db =  FirebaseStorage.instance.ref("images/${teacherId}/${DateTime.now().microsecondsSinceEpoch}");
    await  db.putFile(File(file.path));

    final ImageUrl = await db.getDownloadURL();
    print("----------------------------------------------------${ImageUrl}");

    await sendGroupMessage(token:token , msg: ImageUrl, type:Type.image,teacherId: teacherId);
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

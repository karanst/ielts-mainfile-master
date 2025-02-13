import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ielts/chat/api/apis.dart';
import 'package:ielts/utils/app_constants.dart';

import 'api.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();



String name='';
String email='';
String imageUrl='';
String userId='';

String userImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTP6HBlxRaCn7CViHiZrhpx1Sx4GHM-dafYZZjW0eizMFidSQRS&usqp=CAU';
String errorMessage='';
Future<String?> signInWithGoogle() async {
  DateTime dateTime = DateTime.now();
  Timestamp specificTimeStamp = Timestamp.fromDate(dateTime);
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    final UserCredential authResult = await _auth
        .signInWithCredential(credential)
        .catchError((onError) => print(onError));

    final User user = authResult.user as User;

    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);

    name = user.displayName??'';
    email = user.email??'';
    imageUrl = user.photoURL??'';
    userId = user.uid;

    // Only taking the first part of the name, i.e., First Name
    if (name.contains(" ")) {
      name = name.substring(0, name.indexOf(" "));
    }
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      "is_online": false,
      "last_active": "",
      "posh_token": "",
      "uid": user.uid,
      "name": user.displayName,
      "email": user.email,
      "userImage": user.photoURL,
      "timeStamp":specificTimeStamp
    });

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = await _auth.currentUser as User;
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  } catch (error) {
    return null;
  }
}

Future<String> signIn(String email, String password, bool teacher) async {
  User? user;
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    name = user?.displayName??'';
    email = user?.email??'';
    userId = user?.uid??'';
    if(teacher) {
      await FirebaseFirestore.instance
          .collection("TeacherData")
          .get().then((teacher) async {
        teacher.docs.forEach((element) {
          if (email == element['email']) {
            FirebaseFirestore.instance
                .collection("TeacherData").doc(element['TeacherId']).update({
              'TeacherId': user?.uid ?? ''
            });
            FirebaseFirestore.instance
                .collection("Teacher").get().then((value) async {
              value.docs.forEach((e) {
                if (e.id == element.id.toString()) {
                  FirebaseFirestore.instance
                      .collection("Teacher").doc(e.id).update({
                    'GroupId': user?.uid ?? ''
                  });
                }
              });
            });
          }
        });
      });
    }


  } catch (error) {

   if(error is FirebaseAuthException){
     switch (error.code) {
       case "ERROR_INVALID_EMAIL":
         errorMessage = "Your email address appears to be malformed.";
         break;
       case "ERROR_WRONG_PASSWORD":
         errorMessage = "Your password is wrong.";

         break;
       case "ERROR_USER_NOT_FOUND":
         errorMessage = "User with this email doesn't exist.";
         break;
       case "ERROR_USER_DISABLED":
         errorMessage = "User with this email has been disabled.";
         break;
       case "ERROR_TOO_MANY_REQUESTS":
         errorMessage = "Too many requests. Try again later.";
         break;
       case "ERROR_OPERATION_NOT_ALLOWED":
         errorMessage = "Signing in with Email and Password is not enabled.";
         break;
       default:
         errorMessage = "An undefined Error happened.";
     }
   }
  }
  if (user == null) {
    return Future.error(errorMessage);
  }

  return user.uid;
}
String? pushToken;
 FirebaseMessaging fMessaging = FirebaseMessaging.instance;
Future<String> signUp(String email, String password, String firstName, BuildContext context, bool isTeacher) async {

  await fMessaging.requestPermission();
  await fMessaging.getToken().then((t) {
    if (t != null) {
      pushToken = t;
      log('Push Token: $t');
    }
  });
  DateTime dateTime = DateTime.now();
  Timestamp specificTimeStamp = Timestamp.fromDate(dateTime);
  User? user;

  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    email = user?.email??'';
    userId = user?.uid??'';
print(firstName);
    FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      "is_online": false,
      "last_active": "",
      "posh_token": pushToken,
      "uid": user?.uid,
      "name": firstName,
      "email": email,
      "userImage": userImage,
      "timeStamp":specificTimeStamp,
    });
    if(isTeacher) {
      await FirebaseFirestore.instance
          .collection("TeacherData")
          .get().then((teacher) async {
        teacher.docs.forEach((element) {
          if (email == element['email']) {
            FirebaseFirestore.instance
                .collection("TeacherData").doc(element['TeacherId']).update({
              'TeacherId': user?.uid ?? ''
            });
            FirebaseFirestore.instance
                .collection("Teacher").get().then((value) async {
              value.docs.forEach((e) {
                if (e.id == element.id.toString()) {
                  FirebaseFirestore.instance
                      .collection("Teacher").doc(e.id).update({
                    'GroupId': user?.uid ?? ''
                  });
                }
              });
            });
          }
        });
      });
    }
  } catch (error) {
  if(error is FirebaseAuthException){
    switch (error.code) {
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Anonymous accounts are not enabled";
        break;
      case "ERROR_WEAK_PASSWORD":
        errorMessage = "Your password is too weak";
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email is invalid";
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        errorMessage = "Email is already in use on different account";
        break;
      case "ERROR_INVALID_CREDENTIAL":
        errorMessage = "Your email is invalid";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }
  }
  }
  if (user == null) {
    return Future.error(errorMessage);
  }

  return user.uid;
}

Future<String> anonymousSignIn() async {
  User? user;
  DateTime dateTime = DateTime.now();
  Timestamp specificTimeStamp = Timestamp.fromDate(dateTime);
  try {
    UserCredential result = await _auth.signInAnonymously();

    userId = result.user?.uid??'';

    FirebaseFirestore.instance.collection('users').doc(userId).set({
      "is_online": false,
      "last_active": "",
      "posh_token": "",
      "uid": userId,
      "name": name,
      "email": email,
      "userImage": userImage,
      "timeStamp":specificTimeStamp
    });
  } catch (error) {
    print(error);
  }
  if (user == null) {
    throw Future.error(errorMessage);
  }

  return user.uid;
  // return user.uid;
}

void signOutGoogle(context) async {
  await _auth.signOut();
  await googleSignIn.signOut();
  Navigator.pushReplacementNamed(context, RoutePaths.login);

  print("User Sign Out");
}

Future<void> resetPassword(String email) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
  } catch (error) {
  if(error is FirebaseAuthException){
    switch (error.code) {
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "Email address does not have a account";
        break;
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Invalid email";
        break;

      default:
        errorMessage = "An undefined Error happened.";
    }
  }
  }
  if (errorMessage != null) {
    return Future.error(errorMessage);
  }
}

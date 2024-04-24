// import 'dart:developer';
// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:ielts/chat/halper/form.dart';
// import 'package:ielts/chat/screens/auth/login_screen.dart';
// import 'package:ielts/chat/screens/home_screen.dart';
// import '../../api/apis.dart';
// import '../../halper/dialog.dart';
// import '../../main.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   bool isSigningUp = false;
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   Future<User?> signUpWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       UserCredential credential = await APIs.auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'email-already-in-use') {
//         Dialogs.showSnackbar(context, 'The email address is already in use.');
//       } else {
//         Dialogs.showSnackbar(context, 'An error occurred: ${e.code}');
//       }
//     }
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var mq = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           height: mq.height,
//           child: Stack(
//             children: [
//               AnimatedPositioned(
//                 top: mq.height * 0.10,
//                 right: mq.width * 0.25,
//                 width: mq.width * 0.5,
//                 duration: Duration(seconds: 2),
//                 child: Image.asset('assets/icon.png'),
//               ),
//               Positioned(
//                 bottom: mq.height * 0.20,
//                 right: mq.width * 0.05,
//                 width: mq.width * 0.9,
//                 height: mq.height * 0.45,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Sign Up",
//                       style:
//                           TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 30),
//                     FormContainerWidget(
//                       controller: _usernameController,
//                       hintText: "Username",
//                       isPasswordField: false,
//                     ),
//                     SizedBox(height: 10),
//                     FormContainerWidget(
//                       controller: _emailController,
//                       hintText: "Email",
//                       isPasswordField: false,
//                     ),
//                     SizedBox(height: 10),
//                     FormContainerWidget(
//                       controller: _passwordController,
//                       hintText: "Password",
//                       isPasswordField: true,
//                     ),
//                     SizedBox(height: 30),
//                     GestureDetector(
//                       onTap: () {
//                         _signUp();
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 45,
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: isSigningUp
//                               ? CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               : Text(
//                                   "Sign Up",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Already have an account?"),
//                         SizedBox(width: 5),
//                         GestureDetector(
//                           onTap: () {
//                             // Navigator.pushAndRemoveUntil(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (context) => LoginScreen()),
//                             //     (route) => false);
//                           },
//                           child: Text(
//                             "Login",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _signUp() async {
//     setState(() {
//       isSigningUp = true;
//     });
//
//     String username = _usernameController.text;
//     String email = _emailController.text;
//     String password = _passwordController.text;
//
//     User? user = await signUpWithEmailAndPassword(email, password);
//
//     setState(() {
//       isSigningUp = false;
//     });
//     if (user != null) {
//       // log('\nUser: ${user.user}');
//       // log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
//       if ((await APIs.userExists())) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HomeScreens(),
//           ),
//         );
//       } else {
//         await APIs.createUser().then((value) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => HomeScreens(),
//             ),
//           );
//         });
//       }
//     }
//   }
// }

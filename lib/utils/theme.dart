import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFF21BFBD),
  primaryColor: Color(0xFF21BFBD),
  fontFamily: 'Montserrat',
  brightness: Brightness.light,
  canvasColor: Colors.white, // color for content background
  secondaryHeaderColor: Colors.teal, // side bar color
  hintColor: Colors.black,
  splashColor: Colors.white,
  indicatorColor: Color(0xFF21BFBD), bottomAppBarTheme: BottomAppBarTheme(color: Colors.white), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(background: Color(0xff454dff)), // for appbar in forums and chats
);

final ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.black,
  secondaryHeaderColor: Colors.white,
  canvasColor: Colors.black,
  fontFamily: 'Montserrat',
  hintColor: Colors.white,
  brightness: Brightness.dark,
  splashColor: Color.fromRGBO(37, 42, 65, 1),
  indicatorColor: Color.fromRGBO(18, 22, 33, 1), bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
  // colorScheme: ColorScheme(background: Color.fromRGBO(0, 0, 0, .93)),
);

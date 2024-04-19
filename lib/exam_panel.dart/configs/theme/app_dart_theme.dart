import 'package:flutter/material.dart';
import 'package:ielts/exam_panel.dart/configs/theme/sub_theme_data.dart';

const Color primaryDartColorDart = Color(0xFF2e62);
const Color primaryColorDart = Color(0xFF99ace1);
const Color mainTextColorDark = Colors.white;

class DarkTheme with SubThemeData {
  ThemeData buildDarkTheme() {
    final ThemeData systemDarkTheme = ThemeData.dark();
    return systemDarkTheme.copyWith(
      iconTheme: getIconTheme(),
      textTheme: getTextThemes().apply(
        bodyColor: mainTextColorDark,
        displayColor: mainTextColorDark,
      ),
    );
  }
}

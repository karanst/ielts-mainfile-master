import 'package:flutter/material.dart';
import 'package:ielts/exam_panel.dart/configs/theme/sub_theme_data.dart';

const Color primaryLightColorLight = Color(0xFF3acb);
const Color primaryColorLight = Color(0xFFf85187);
const Color mainTextColorLight = Color.fromARGB(255, 40, 40, 40);

class LightTheme with SubThemeData {
  buildLightTheme() {
    final ThemeData systemLightTheme = ThemeData.light();
    return systemLightTheme.copyWith(
      iconTheme: getIconTheme(),
      textTheme: getTextThemes().apply(
        bodyColor: mainTextColorLight,
        displayColor: mainTextColorLight,
      ),
    );
  }
}

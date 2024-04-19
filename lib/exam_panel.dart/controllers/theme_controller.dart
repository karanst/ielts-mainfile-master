import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_dart_theme.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_light_theme.dart';

class ThemeController extends GetxController {
  late ThemeData _darkTheme;
  late ThemeData _lightTheme;

  @override
  void onInit() {
    initializeThemeData();
    super.onInit();
  }

  void initializeThemeData() {
    // Dark theme colors
    _darkTheme = DarkTheme().buildDarkTheme();
    _lightTheme = LightTheme().buildLightTheme();
  }

  ThemeData get darkTheme => _darkTheme;
  ThemeData get lightTheme => _lightTheme;
}

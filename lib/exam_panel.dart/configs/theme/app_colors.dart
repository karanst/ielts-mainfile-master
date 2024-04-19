import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_dart_theme.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_light_theme.dart';
import 'package:ielts/exam_panel.dart/configs/theme/ui_paramiter.dart';

const Color onSurfaceTextColor = Colors.white;
const mainGradientLight = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    primaryLightColorLight,
    primaryColorLight,
  ],
);
const mainGradientDark = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    primaryDartColorDart,
    primaryColorDart,
  ],
);
LinearGradient mainGradient(BuildContext context) =>
    UIParamiter.isDarkMode(context) ? mainGradientDark : mainGradientLight;

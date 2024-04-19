import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ielts/exam_panel.dart/configs/theme/app_colors.dart';

mixin SubThemeData {
  getTextThemes() {
    return GoogleFonts.quicksandTextTheme(
      TextTheme(
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  IconThemeData getIconTheme() {
    return const IconThemeData(color: onSurfaceTextColor, size: 16);
  }
}

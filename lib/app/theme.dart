import 'package:flutter/material.dart';

abstract class BaseColors {
  static Color red = const Color(0xff67100c);
  static Color blond = const Color(0xffffefbc);
  static Color darkJungle = const Color(0xff13182d);
  static Color beige = const Color(0xffcdae83);
  static Color darkBlue = const Color(0xff202433);
  static Color text = Colors.white;
  static Color textSecondary = Colors.white54;
}

abstract class Fonts {
  static const String almendra = 'Almendra';
  static const String tajawal = 'Tajawal';
  static const String roboto = 'Roboto';
}

ThemeData themeData = ThemeData.from(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blueGrey,
  ),
);

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:werewolves/theme/theme.dart';

void showToast(
  String msg, {
  double size = 12,
  Toast length = Toast.LENGTH_LONG,
  Color? color,
  Color? textColor,
}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: color ?? BaseColors.blond,
    textColor: textColor ?? BaseColors.darkBlue,
    fontSize: size,
    toastLength: length,
  );
}

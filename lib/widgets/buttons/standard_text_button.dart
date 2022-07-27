import 'package:flutter/material.dart';

Widget standardTextButton(String text, Function onPressed) {
  return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(text));
}

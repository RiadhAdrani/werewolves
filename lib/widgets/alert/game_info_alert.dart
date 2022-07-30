import 'package:flutter/material.dart';
import 'package:werewolves/widgets/buttons/standard_text_button.dart';

void showInfoAlert(
  String title,
  String text,
  BuildContext context,
) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              standardTextButton('Okay', () {
                Navigator.pop(context);
              }),
            ],
          ),
        );
      });
}

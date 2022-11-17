import 'package:flutter/material.dart';
import 'package:werewolves/widgets/common.dart';

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
              button('Okay', () {
                Navigator.pop(context);
              }),
            ],
          ),
        );
      });
}

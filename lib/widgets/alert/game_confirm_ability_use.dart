import 'package:flutter/material.dart';
import 'package:werewolves/widgets/buttons/standard_text_button.dart';

void showConfirmAlert(
  String title,
  String text,
  BuildContext context,
  Function onConfirm,
) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            standardTextButton('Cancel', () => Navigator.pop(context)),
            standardTextButton('Confirm', () {
              Navigator.pop(context);
              onConfirm();
            }),
          ],
        );
      });
}

import 'package:flutter/material.dart';
import 'package:werewolves/widgets/buttons/standard_text_button.dart';

void showAbilityAppliedMessage(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ability use:'),
          content: Text(message),
          actions: [
            standardTextButton('Okay', () {
              Navigator.pop(context);
            })
          ],
        );
      });
}

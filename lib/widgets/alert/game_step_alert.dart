import 'package:flutter/material.dart';
import 'package:werewolves/widgets/buttons/standard_text_button.dart';

void showStepAlert(String title, String text, List<String> items,
    BuildContext context, Function onNext) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Column(
              children: [
                Text(text),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: ListView(
                    children: items.map((item) => Text(item)).toList(),
                  ),
                )
              ],
            ),
            actions: [
              standardTextButton('Okay', () {
                Navigator.pop(context);
                onNext();
              }),
            ],
          ),
        );
      });
}

import 'package:flutter/material.dart';
import 'package:werewolves/widgets/common.dart';

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
              button('Okay', () {
                Navigator.pop(context);
                onNext();
              }),
            ],
          ),
        );
      });
}

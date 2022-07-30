import 'package:flutter/material.dart';
import 'package:werewolves/widgets/text/title_with_icon.dart';

Widget daySectionView(String title,IconData icon, List<String> list, {bool expanded = false}) {
  return ExpansionTile(
    initiallyExpanded: expanded,
    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
    backgroundColor: Colors.grey[350],
    title: titleWithIcon(
      title, 
      icon,
      alignment: MainAxisAlignment.start
    ),
    children: list
        .map((item) => Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            )))
        .toList(),
  );
}

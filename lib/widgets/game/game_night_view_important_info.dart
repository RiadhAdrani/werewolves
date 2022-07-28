import 'package:flutter/material.dart';
import 'package:werewolves/widgets/text/title_with_icon.dart';

Widget importantInformationsView(List<String> infoList) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        smallTitleWithIcon(
          'Important informations', 
          Icons.announcement_outlined, 
          color: Colors.blueGrey[800]!
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: infoList.map((text) {
            return Card(
              margin: const EdgeInsets.all(2),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blueGrey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              ),
            );
          }).toList(),
        )
      ],
    ),
  );
}

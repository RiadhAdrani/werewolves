import 'package:flutter/material.dart';

Widget gameSimpleData(String text) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [Text(text)]),
    ),
  );
}

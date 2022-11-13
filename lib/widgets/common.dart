import 'package:flutter/material.dart';

Widget button(String text, Function onClick, {bool flat = false}) {
  Widget content = Text(text);

  if (flat) {
    return TextButton(
      onPressed: () => onClick(),
      child: content,
    );
  } else {
    return ElevatedButton(
      onPressed: () => onClick(),
      child: content,
    );
  }
}

FloatingActionButton fab(IconData icon, Function onClick) {
  return FloatingActionButton(
    onPressed: () => onClick(),
    child: Icon(icon),
  );
}

Widget card({bool isSelected = false, Widget child = const Text('card')}) {
  return Card(
    color: isSelected ? Colors.grey[300] : Colors.white,
    child: child,
  );
}

Text text(String data,
    {Color color = Colors.black,
    FontWeight weight = FontWeight.normal,
    double size = 14,
    bool italic = false,
    bool overflow = true,
    bool justify = false}) {
  return Text(
    data,
    textAlign: justify ? TextAlign.justify : TextAlign.start,
    style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal),
    overflow: overflow ? TextOverflow.visible : TextOverflow.fade,
  );
}

Text headingTitle(
  String data, {
  Color color = Colors.black,
  FontWeight weight = FontWeight.bold,
  bool italic = false,
}) {
  return text(data,
      color: color, weight: weight, size: 24, italic: italic, overflow: false);
}

Text title(String data,
    {Color color = Colors.black,
    FontWeight weight = FontWeight.bold,
    bool italic = false}) {
  return text(data,
      color: color, weight: weight, size: 20, italic: italic, overflow: false);
}

Text subTitle(String data,
    {Color color = Colors.black,
    FontWeight weight = FontWeight.w600,
    bool italic = false}) {
  return text(data,
      color: color, weight: weight, size: 16, italic: italic, overflow: false);
}

Text paragraph(String data,
    {Color color = Colors.black45,
    FontWeight weight = FontWeight.normal,
    bool italic = false}) {
  return text(data,
      color: color,
      weight: weight,
      size: 12,
      italic: italic,
      overflow: true,
      justify: true);
}

Widget padding(List<double> padding, Widget child) {
  EdgeInsetsGeometry p = EdgeInsets.zero;

  if (padding.isEmpty) {
    p = EdgeInsets.zero;
  } else if (padding.length == 1) {
    p = EdgeInsets.all(padding[0]);
  } else if (padding.length == 2) {
    p = EdgeInsets.symmetric(vertical: padding[0], horizontal: padding[1]);
  } else if (padding.length == 3) {
    p = EdgeInsets.fromLTRB(0, padding[0], padding[1], padding[2]);
  } else if (padding.length > 3) {
    p = EdgeInsets.fromLTRB(padding[3], padding[0], padding[1], padding[2]);
  }

  return Padding(padding: p, child: child);
}

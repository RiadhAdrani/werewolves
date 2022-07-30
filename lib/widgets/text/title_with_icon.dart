import 'package:flutter/material.dart';

Widget smallTitleWithIcon(
  String title, 
  IconData icon, 
  {
    Color color = Colors.black, 
    MainAxisAlignment alignment = MainAxisAlignment.center
  }
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical:6.0),
    child: Row(
      mainAxisAlignment: alignment,
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
}

Widget titleWithIcon(
  String title, 
  IconData icon, 
  {
    Color color = Colors.black, 
    MainAxisAlignment alignment = MainAxisAlignment.center
  }
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical:6.0),
    child: Row(
      mainAxisAlignment: alignment,
      children: [
        Icon(
          icon,
          size: 30,
          color: color,
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
        Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: TextStyle(
              color: color,
              fontSize: 18,
              fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
}

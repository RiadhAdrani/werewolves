import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

Widget roleWithPlayerName(Role role, BuildContext context) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          role.player.id,
          style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey[900],
              fontWeight: FontWeight.bold),
        ),
        Text(
          role.getName(),
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        )
      ]),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/widgets/common.dart';

Widget roleWithPlayerName(Role role, BuildContext context) {
  return card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          role.player.name,
          style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey[900],
              fontWeight: FontWeight.bold),
        ),
        Text(
          role.name,
          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        )
      ]),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

Widget roleInfoIconNamePlayer(Role role) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(children: [
      Image.asset(role.icon),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          role.icon,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          '(${role.getPlayerName()})',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    ]),
  );
}

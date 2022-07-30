import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

Widget roleInfoIconNamePlayer(Role role) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(children: [
      Image.asset(role.getIcon()),
      Text(
        role.getName(),
        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      ),
      Text(
        '(${role.getPlayerName()})',
        style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
      ),
      
    ]),
  );
}

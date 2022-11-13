import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

AlertDialog confirmDistributedList(
    List<Role> list, Function onConfirm, Function onCancel) {
  return AlertDialog(
    title: const Text('Review players list'),
    content: SizedBox(
      width: 300,
      child: ListView(
        children: list.map((role) {
          var playerName = role.player.id as String;

          return Text('${role.name} : $playerName');
        }).toList(),
      ),
    ),
    actions: [
      TextButton(onPressed: () => onConfirm(), child: const Text('Confirm')),
      TextButton(onPressed: () => onCancel(), child: const Text('Cancel'))
    ],
  );
}

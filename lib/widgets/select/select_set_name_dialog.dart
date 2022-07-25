import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

AlertDialog setPlayerNameDialog(Role temp, TextEditingController controller,
    BuildContext context, Function onDone, Function onCancel) {
  return AlertDialog(
    title: Text(
      temp.getName(),
      style: const TextStyle(fontSize: 20),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter player name'),
        ),
        const Padding(padding: EdgeInsets.all(5)),
        const Text('No duplicate name allowed', style: TextStyle(fontSize: 14)),
        const Text('Minimum size is 3', style: TextStyle(fontSize: 14))
      ],
    ),
    actions: [
      TextButton(
          onPressed: () {
            onDone();
          },
          child: const Text('Done')),
      TextButton(
          onPressed: () {
            onCancel();
          },
          child: const Text('Cancel'))
    ],
  );
}

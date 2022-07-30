import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

AlertDialog setPlayerNameDialog(Role temp, TextEditingController controller,
    BuildContext context, Function onDone, Function onCancel) {
  return AlertDialog(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(temp.getIcon()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            temp.getName(),
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLength: 25,
          decoration: const InputDecoration(hintText: 'Enter player name'),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:const  [
            Text('• No duplicate name allowed',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
          Text('• Minimum size is 3',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
          Text('• Maximum size is 25',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
          Text('• Only alphanumerical characters and space are allowed.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic))
          ],),
        )
        
        
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

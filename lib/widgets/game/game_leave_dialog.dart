import 'package:flutter/material.dart';

void onGameExit(BuildContext context) {
  showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            title: const Text('Game in progress'),
            content: const Text('Are you sure you want to abandon the game ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  },
                  child: const Text('Leave game')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Continure playing'))
            ],
          )));
}

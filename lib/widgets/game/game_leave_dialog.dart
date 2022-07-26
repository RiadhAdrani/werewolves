import 'package:flutter/material.dart';

void onGameExit(BuildContext context){
  showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text('Game in progress'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
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
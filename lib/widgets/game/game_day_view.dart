import 'package:flutter/material.dart';
import 'package:werewolves/models/game_model.dart';

Widget gameDayView(GameModel game) {
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Day'),
    ),
    body: Center(
      child: Column(
        children: [
          const Text('Day'),
          TextButton(
              onPressed: () {
                game.startTurn();
              },
              child: const Text('Start night'))
        ],
      ),
    ),
  );
}

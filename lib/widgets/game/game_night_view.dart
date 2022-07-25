import 'package:flutter/material.dart';
import 'package:werewolves/models/game_model.dart';

Widget gameNightView(GameModel game) {
  return Column(
    children: [
      AppBar(
        title: const Text('The night'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
      ),
      Text(
        game.getCurrent()!.getName(), 
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),
      ),
      Text(
        game.getCurrent()!.getPlayerName(), 
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      TextButton(
          onPressed: () {
            game.next();
          },
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
            ),
          )
        )
    ],
  );
}

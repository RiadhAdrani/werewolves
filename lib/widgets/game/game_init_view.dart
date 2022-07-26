import 'package:flutter/material.dart';
import 'package:werewolves/models/game_model.dart';

Widget gameInitView(GameModel game, BuildContext context) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Everything is ready !', 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        TextButton(
            onPressed: () {
              game.startTurn();
            },
            child: const Text(
              'Start game',
              style: TextStyle(
                fontSize: 16,
              ),
            )
          )
      ],
    ),
  );
}

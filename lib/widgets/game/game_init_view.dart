import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';

Widget gameInitView(Game game, BuildContext context) {
  return ColoredBox(
    color: Colors.blueGrey[900]!,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Everything is ready !',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TextButton(
              onPressed: () {
                game.startTurn();
              },
              child: Text(
                'Start game',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[300]!),
              ))
        ],
      ),
    ),
  );
}

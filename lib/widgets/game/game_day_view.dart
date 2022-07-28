import 'package:flutter/material.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/widgets/game/game_app_bar.dart';
import 'package:werewolves/widgets/game/game_day_view_info_list.dart';

Widget gameDayView(GameModel game, BuildContext context) {
  return Scaffold(
    appBar: gameAppBar(
      'Day (${game.getCurrentTurn()})',
      context, 
      backgroundColor: Colors.blue[100]!
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          endOfNightinforListView(game),
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

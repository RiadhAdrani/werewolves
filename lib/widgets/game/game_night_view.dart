import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/widgets/game/game_app_bar.dart';
import 'package:werewolves/widgets/game/game_night_view_important_info.dart';
import 'package:werewolves/widgets/game/game_night_view_abilities.dart';
import 'package:werewolves/widgets/game/game_night_view_role_info.dart';

Widget gameNightView(GameModel game, BuildContext context) {
  return Scaffold(
    appBar: gameAppBar('Night (${game.getCurrentTurn()})', context,
        backgroundColor: Colors.blueGrey[900]!, textColor: Colors.white),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          roleInfoIconNamePlayer(game.getCurrent()!),
          Divider(color: Colors.blueGrey[100],),
          importantInformationsView(game.getCurrent()!.getInformations(game)),
          Divider(color: Colors.blueGrey[100],),
          abilitiesView(game, context),
          TextButton(
              onPressed: () {
                game.next(context);
              },
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                ),
              ))
        ],
      ),
    ),
  );
}

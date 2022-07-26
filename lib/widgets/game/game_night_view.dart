import 'package:flutter/material.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/widgets/cards/ability_card_view.dart';
import 'package:werewolves/widgets/game/game_leave_dialog.dart';

Widget gameNightView(GameModel game, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppBar(
        title: Text('Night (${game.getCurrentTurn()})'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey[900],
        actions: [
          TextButton(
              onPressed: () {
                onGameExit(context);
              },
              child: const Text(
                'Leave',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.person,
              size: 50,
            ),
            Text(
              game.getCurrent()!.getName(),
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              game.getCurrent()!.getPlayerName(),
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: game
                .getCurrent()!
                .abilities
                .where((ability) =>
                    ability.isNightAbility() &&
                    ability.shouldAbilityBeAvailable())
                .map((ability) => abilityCardView(ability, () {}))
                .toList(),
          ),
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
          ))
    ],
  );
}

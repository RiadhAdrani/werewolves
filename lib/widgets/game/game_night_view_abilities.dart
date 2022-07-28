import 'package:flutter/material.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/widgets/cards/ability_card_view.dart';
import 'package:werewolves/widgets/game/game_use_ability.dart';
import 'package:werewolves/widgets/text/title_with_icon.dart';

Widget abilitiesView(GameModel game, BuildContext context) {
  final abilities = game
      .getCurrent()!
      .abilities
      .where((ability) => game.isAbilityAvailableAtNight(ability))
      .toList();

  return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:8.0),
        child: Column(
          children: [
            smallTitleWithIcon('Remaining abilities', Icons.list_alt_outlined,
                color: Colors.blueGrey[800]!),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: abilities.length,
                itemBuilder: (context, index) {
                  final ability = abilities[index];

                  return abilityCardView(ability, () {
                    showUseAbilityDialog(context, game, ability);
                  });
                },
              ),
            )
          ],
        ),
      ));
}

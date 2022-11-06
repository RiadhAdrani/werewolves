import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/widgets/game/ability/use_alien_ability.dart';
import 'package:werewolves/widgets/game/ability/use_normal_ability.dart';

void showUseAbilityDialog(BuildContext context, GameModel game, Ability ability,
    Function(List<Player>) onAbilityUsed,
    {bool cancelable = true}) {
  List<Player> targetList = ability.createListOfTargetPlayers(game);

  switch (ability.ui) {
    case AbilityUI.normal:
      showNormalAbilityDialog(context, ability, targetList, onAbilityUsed);
      break;
    case AbilityUI.alien:
      showAlienAbilityDialog(
        context,
        ability,
        targetList,
        onAbilityUsed,
        game.getPlayableRoles(),
      );
      break;
  }
}

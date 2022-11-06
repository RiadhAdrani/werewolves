import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/garrulous_word.dart';

class GarrulousWolf extends RoleSingular {
  GarrulousWolf(super.player) {
    id = RoleId.garrulousWolf;
    callingPriority = garrulousWolfCallPriority;
    isWolf = true;
    super.abilities = [GarrulousAbility(this)];
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return false;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return [
      'The narrator should give you a word that you must include in your speech during the day phase. (Use The "Write" button to communicate the word.)',
      'In case you did not say the word, you will be eliminated from the game.'
    ];
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.wolves;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }
}

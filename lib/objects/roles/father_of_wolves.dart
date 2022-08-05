// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/father_infect.dart';

class FatherOfWolves extends RoleSingular {
  FatherOfWolves(super.player) {
    id = RoleId.fatherOfWolves;
    isWolf = true;
    callingPriority = fatherOfWolvesCallPriority;
    abilities = [InfectAbility(this)];

    /// TODO : check for these cases when adding new roles
    /// A servant with [love effect] transformed into a werewolf should not change its team.

    if (player.roles.length == 1) {
      player.team = Teams.wolves;
    }
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return true;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return game.getCurrentTurn() > 1;
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return [
      'Do you want to infect the player that you killed wth the wolfpack ?'
    ];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Teams getSupposedInitialTeam() {
    return Teams.wolves;
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }
}

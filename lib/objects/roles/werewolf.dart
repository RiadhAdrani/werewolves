// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';

class Werewolf extends RoleSingular {
  Werewolf(super.player) {
    id = RoleId.werewolf;
    isWolf = true;
    isUnique = false;

    /// TODO : check for these cases when adding new roles
    /// A servant with [love effect] transformed into a werewolf should not change its team.

    if (player.roles.length == 1) {
      player.team = Team.wolves;
    }
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
  bool shouldBeCalledAtNight(Game game) {
    return false;
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return [];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.wolves;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

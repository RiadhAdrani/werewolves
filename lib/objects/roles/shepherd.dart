// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/ability/shepherd_sheeps.dart';

class Shepherd extends RoleSingular {
  Shepherd(super.player) {
    id = RoleId.shepherd;
    callingPriority = shepherdCallPriority;
    abilities = [ShepherdAbility(this)];
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
    var maybeAbility = getAbilityOfType(AbilityId.sheeps);

    if (maybeAbility == null) {
      return false;
    } else {
      return maybeAbility.targetCount > 0;
    }
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return ['Pick a target to send the sheeps to.'];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }
}

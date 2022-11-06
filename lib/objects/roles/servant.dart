// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/ability/servant_serve.dart';

class Servant extends RoleSingular {
  Servant(super.player) {
    id = RoleId.servant;
    callingPriority = servantCallPriority;
    abilities = [ServantAbility(this)];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
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
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return [
      'The servant shall choose a target.',
      'If the chosen player dies, the servant takes his role.'
    ];
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return player.hasEffect(StatusEffectType.isServing) == false;
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }
}

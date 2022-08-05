// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/role_single.dart';
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
  Teams getSupposedInitialTeam() {
    return Teams.village;
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

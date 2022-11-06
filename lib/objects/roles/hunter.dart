// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/ability/hunter_callsign.dart';
import 'package:werewolves/objects/ability/hunter_hunt.dart';

class Hunter extends RoleSingular {
  Hunter(super.player) {
    id = RoleId.hunter;
    callingPriority = hunterCallPriority;
    abilities = [
      CallSignAbility(this),
      HuntAbility(this),
    ];
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return player.hasFatalEffect() ||
        !player.hasEffect(StatusEffectType.hasCallsign);
  }

  @override
  bool canUseSignWithNarrator() {
    return true;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return player.hasFatalEffect() ||
        !player.hasEffect(StatusEffectType.hasCallsign);
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    if (player.hasFatalEffect()) {
      return ['You have become a Hunter! Choose someone to kill.'];
    }

    if (!player.hasEffect(StatusEffectType.hasCallsign)) {
      return [
        'You should give the narrator a call sign that you may use during the day phase to kill a werewolf.',
      ];
    }

    return [];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return true;
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

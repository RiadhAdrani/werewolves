// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';

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

class HuntEffect extends StatusEffect {
  HuntEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isHunted;
  }
}

class HuntAbility extends Ability {
  HuntAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.hunt;
    super.type = AbilityType.both;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.both;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(HuntEffect(owner));

    if (!target.hasWolfRole()) {
      (owner as RoleSingular).player.addStatusEffect(HuntEffect(owner));
    }
  }

  @override
  bool isTarget(Player target) {
    return target != owner.player;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return (owner.player as Player).hasFatalEffect();
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was killed.';

    return '${targets[0].name} has been killed.';
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return owner.playerIsFatallyWounded();
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return true;
  }
}

class CallSignAbility extends Ability {
  CallSignAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.callsign;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(CallSignEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target == owner.player;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.player as Player).hasEffect(StatusEffectType.hasCallsign) &&
        !(owner.player as Player).hasFatalEffect();
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'Hunter did not give his signal';

    return '${targets[0].name} has given his call sign.';
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return !(owner.player as Player).hasEffect(StatusEffectType.hasCallsign) &&
        !(owner.player as Player).hasFatalEffect();
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

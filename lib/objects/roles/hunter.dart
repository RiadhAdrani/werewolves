// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';

class Hunter extends RoleSingular {
  Hunter(super.player) {
    callingPriority = hunterPriority;
    abilities = [
      CallSignAbility(this),
      HuntAbility(this),
    ];
  }

  @override
  RoleId get id {
    return RoleId.hunter;
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return controller.hasFatalEffect ||
        !controller.hasEffect(EffectId.hasCallsign);
  }

  @override
  bool canUseSignWithNarrator() {
    return true;
  }

  @override
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return controller.hasFatalEffect ||
        !controller.hasEffect(EffectId.hasCallsign);
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    if (controller.hasFatalEffect) {
      return ['You have become a Hunter! Choose someone to kill.'];
    }

    if (!controller.hasEffect(EffectId.hasCallsign)) {
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
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

class HuntedEffect extends Effect {
  HuntedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isHunted;
  }
}

class HuntAbility extends Ability {
  HuntAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.hunt;
    super.type = AbilityType.both;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.both;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(HuntedEffect(owner));

    if (!target.hasWolfRole) {
      (owner as RoleSingular).controller.addEffect(HuntedEffect(owner));
    }
  }

  @override
  bool isTarget(Player target) {
    return target != owner.controller;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return (owner.controller as Player).hasFatalEffect;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return owner.playerIsFatallyWounded();
  }

  @override
  bool shouldBeUsedOnDeath() {
    return true;
  }
}

class CallSignAbility extends Ability {
  CallSignAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.callsign;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(HasCallSignEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target == owner.controller;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.controller as Player).hasEffect(EffectId.hasCallsign) &&
        !(owner.controller as Player).hasFatalEffect;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return !(owner.controller as Player).hasEffect(EffectId.hasCallsign) &&
        !(owner.controller as Player).hasFatalEffect;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

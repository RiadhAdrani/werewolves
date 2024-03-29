// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Seer extends RoleSingular {
  Seer(super.player) {
    callingPriority = seerPriority;
    abilities = [ClairvoyanceAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.seer;
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
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return true;
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return ['Pick a target to reveal his true role.'];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

Role resolveSeenRole(Player player) {
  return player.mainRole;
}

class ClairvoyanceEffect extends Effect {
  ClairvoyanceEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isSeen;
  }
}

class ClairvoyanceAbility extends Ability {
  ClairvoyanceAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.clairvoyance;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(ClairvoyanceEffect(owner));
  }

  @override
  bool isTarget(Player target, int turn) {
    return true;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return true;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

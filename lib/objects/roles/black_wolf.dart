import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/objects/roles/werewolf.dart';

class BlackWolf extends Werewolf {
  BlackWolf(super.player) {
    callingPriority = blackWolfPriority;

    super.abilities = [MuteAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.blackWolf;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
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
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return ["Choose a player to mute"];
  }

  @override
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return true;
  }
}

class MutedEffect extends Effect {
  MutedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isMuted;
  }
}

class WasMutedEffect extends Effect {
  WasMutedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.wasMuted;
  }
}

class MuteAbility extends Ability {
  MuteAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.mute;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(MutedEffect(owner));
  }

  @override
  bool isTarget(Player target, int turn) {
    return !target.hasEffect(EffectId.wasMuted);
  }

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return !target.hasEffect(EffectId.isProtected);
  }

  @override
  bool shouldBeAvailable() {
    return true;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}
}

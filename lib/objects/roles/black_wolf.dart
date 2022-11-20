import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class BlackWolf extends RoleSingular {
  BlackWolf(super.player) {
    id = RoleId.blackWolf;
    callingPriority = blackWolfPriority;

    isWolf = true;

    super.abilities = [MuteAbility(this)];

    onCreated();
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
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    return ["Choose a player to mute"];
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.wolves;
  }

  @override
  bool shouldBeCalledAtNight(Game game) {
    return true;
  }
}

class MuteEffect extends Effect {
  MuteEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isMuted;
  }
}

class WasMutedEffect extends Effect {
  WasMutedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.wasMuted;
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
    target.addEffect(MuteEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return !target.hasEffect(EffectId.wasMuted);
  }

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    return "Player muted";
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
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}
}

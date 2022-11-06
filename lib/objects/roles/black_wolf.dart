import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class BlackWolf extends RoleSingular {
  BlackWolf(super.player) {
    id = RoleId.blackWolf;
    callingPriority = blackWolfCallPriority;

    isWolf = true;

    super.abilities = [MuteAbility(this)];
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
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
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return ["Choose a player to mute"];
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.wolves;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }
}

class MuteEffect extends StatusEffect {
  MuteEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isMuted;
  }
}

class WasMutedEffect extends StatusEffect {
  WasMutedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.wasMuted;
  }
}

class MuteAbility extends Ability {
  MuteAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.mute;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(MuteEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return !target.hasEffect(StatusEffectType.wasMuted);
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
    return !target.hasEffect(StatusEffectType.isProtected);
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
  void usePostEffect(GameModel game, List<Player> affected) {}
}

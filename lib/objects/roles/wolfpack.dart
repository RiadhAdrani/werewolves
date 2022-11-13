// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Wolfpack extends RoleGroup {
  Wolfpack(super.player) {
    id = RoleId.wolfpack;
    callingPriority = wolfpackCallPriority;
    abilities = [DevourAbility(this)];
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
  bool shouldBeCalledAtNight(Game game) {
    return hasAtLeastOneSurvivingMember();
  }

  @override
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    return ['Assembe wolfpack.', 'Choose your victim.'];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.wolves;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }

  /// Check if the team of the player should be changed to wolves
  /// when he is infected.
  static bool shouldJoinWolfpackUponInfection(Player player) {
    RoleId mainRole = player.getMainRole().id;

    switch (mainRole) {
      case RoleId.protector:
      case RoleId.werewolf:
      case RoleId.fatherOfWolves:
      case RoleId.witch:
      case RoleId.seer:
      case RoleId.knight:
      case RoleId.hunter:
      case RoleId.captain:
      case RoleId.villager:
      case RoleId.wolfpack:
      case RoleId.servant:
      case RoleId.judge:
      case RoleId.blackWolf:
      case RoleId.garrulousWolf:
      case RoleId.shepherd:
        return true;
      case RoleId.alien:
        return false;
    }
  }
}

class DevourEffect extends Effect {
  DevourEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isDevoured;
  }
}

class DevourAbility extends Ability {
  DevourAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.devour;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(DevourEffect(owner));
  }

  @override
  bool isTarget(Player target) {
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
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body has been devoured';

    return '${targets[0].name} has been devoured.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

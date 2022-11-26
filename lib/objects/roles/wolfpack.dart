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
    callingPriority = wolfpackPriority;
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
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return ['Assemble wolfpack.', 'Choose your victim.'];
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
    RoleId mainRole = player.mainRole.id;

    // TODO : add other solos here
    List<RoleId> nonConvertible = [RoleId.alien];

    return !nonConvertible.contains(mainRole);
  }
}

class DevouredEffect extends Effect {
  DevouredEffect(Role source) {
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
    target.addEffect(DevouredEffect(owner));
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
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

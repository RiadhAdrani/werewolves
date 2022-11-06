// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

class FatherOfWolves extends RoleSingular {
  FatherOfWolves(super.player) {
    id = RoleId.fatherOfWolves;
    isWolf = true;
    callingPriority = fatherOfWolvesCallPriority;
    abilities = [InfectAbility(this)];

    // TODO : check for these cases when adding new roles
    // A servant with [love effect] transformed into a werewolf should not change its team.

    if (player.roles.length == 1) {
      player.team = Team.wolves;
    }
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
    return game.currentTurn > 1;
  }

  @override
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    return [
      'Do you want to infect the player that you killed wth the wolfpack ?'
    ];
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
}

class InfectEffect extends Effect {
  InfectEffect(Role source) {
    this.source = source;
    permanent = true;
    type = EffectId.isInfected;
  }
}

class InfectAbility extends Ability {
  InfectAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.infect;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.removeEffectsOfType(EffectId.isDevoured);
    target.addStatusEffect(InfectEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target.hasEffect(EffectId.isDevoured) && !target.hasWolfRole();
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
    if (targets.isEmpty) return 'No body was infected.';

    return '${targets[0].name} has been infected and will join the Wolfpack.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {
    if (affected.isEmpty) return;

    var newMember = affected[0];

    if (Wolfpack.shouldJoinWolfpackUponInfection(newMember)) {
      newMember.team = Team.wolves;
    }

    game.addMemberToGroup(newMember, RoleId.wolfpack);
  }

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/objects/roles/werewolf.dart';

class FatherOfWolves extends Werewolf {
  FatherOfWolves(super.player) {
    callingPriority = fatherOfWolvesPriority;
    abilities = [InfectAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.fatherOfWolves;
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
    return turn > 1;
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return [
      'Do you want to infect the player that you killed wth the wolfpack ?'
    ];
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

class InfectedEffect extends Effect {
  InfectedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isInfected;
  }

  @override
  bool get isPermanent {
    return true;
  }
}

class InfectAbility extends Ability {
  InfectAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.infect;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.removeEffectsOfType(EffectId.isDevoured);
    target.addEffect(InfectedEffect(owner));
  }

  @override
  bool isTarget(Player target, int turn) {
    return target.hasEffect(EffectId.isDevoured) && !target.hasWolfRole;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return target.hasEffect(EffectId.isDevoured);
  }

  @override
  bool shouldBeAvailable() {
    return true;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {
    if (affected.isEmpty) return;

    var newMember = affected[0];

    game.addMemberToGroup(newMember, RoleId.wolfpack);
  }

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

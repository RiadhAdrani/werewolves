// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Captain extends RoleSingular {
  Captain(super.player) {
    callingPriority = captainPriority;

    super.abilities = [
      ExecuteAbility(this),
      SubstitueAbility(this),
      TalkerAbility(this),
      InheritAbility(this)
    ];
  }

  @override
  RoleId get id {
    return RoleId.captain;
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
    final output = <String>[];

    if (controller.hasFatalEffect) {
      output.add(
          'You are dead, choose another fellow player to inherit your captaincy.');
    }

    output.add('Choose a player whom will start the discussion.');

    return output;
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

class ExecutedEffect extends Effect {
  ExecutedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isExecuted;
  }
}

class InheritedCaptaincyEffect extends Effect {
  InheritedCaptaincyEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.hasInheritedCaptaincy;
  }
}

class SubstitutedEffect extends Effect {
  SubstitutedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isSubstitue;
  }
}

class ShouldTalkFirstEffect extends Effect {
  ShouldTalkFirstEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.shouldTalkFirst;
  }
}

class ExecuteAbility extends Ability {
  ExecuteAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.execute;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.day;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(ExecutedEffect(owner));
  }

  @override
  bool isTarget(Player target) {
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
    return false;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

class InheritAbility extends Ability {
  InheritAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.inherit;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.both;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(InheritedCaptaincyEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return !target.hasFatalEffect;
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
  void usePostEffect(Game game, List<Player> affected) {
    if (affected.isEmpty) return;

    game.replaceCaptainPlayer(affected[0]);
  }

  @override
  bool isUnskippable() {
    return owner.playerIsFatallyWounded();
  }

  @override
  bool shouldBeUsedOnDeath() {
    return true;
  }
}

class SubstitueAbility extends Ability {
  SubstitueAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.substitute;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(SubstitutedEffect(owner));
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
    return false;
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

class TalkerAbility extends Ability {
  TalkerAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.talker;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(ShouldTalkFirstEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return true;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.controller as Player).hasFatalEffect;
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

// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Judge extends RoleSingular {
  Judge(super.player) {
    callingPriority = judgePriority;
    abilities = [JudgementAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.judge;
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
    return [
      "The judge choose a player to protect.",
      "The protected player cannot be voted on by the villagers.",
      "The judge cannot choose the same player twice in a row."
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

class JudgedEffect extends Effect {
  JudgedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isJudged;
  }
}

class WasJudgedEffect extends Effect {
  WasJudgedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.wasJudged;
  }
}

class JudgementAbility extends Ability {
  JudgementAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.judgement;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(JudgedEffect(owner));
  }

  @override
  bool isTarget(Player target, int turn) {
    return !target.hasEffect(EffectId.wasJudged);
  }

  @override
  bool isUnskippable() {
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
  bool shouldBeUsedOnDeath() {
    return false;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}
}

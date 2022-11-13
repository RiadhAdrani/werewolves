// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Judge extends RoleSingular {
  Judge(super.player) {
    id = RoleId.judge;
    callingPriority = judgePriority;
    abilities = [JudgementAbility(this)];
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
    return true;
  }

  @override
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
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
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

class JudgedEffect extends Effect {
  JudgedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isJudged;
  }
}

class WasJudgedEffect extends Effect {
  WasJudgedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.wasJudged;
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
  bool isTarget(Player target) {
    return !target.hasEffect(EffectId.wasJudged);
  }

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    return "Player cannot be voted on.";
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
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}
}

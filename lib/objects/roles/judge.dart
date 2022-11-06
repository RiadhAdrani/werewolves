// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class Judge extends RoleSingular {
  Judge(super.player) {
    id = RoleId.judge;
    callingPriority = judgeCallPriority;
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
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
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
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }
}

class JudgedEffect extends StatusEffect {
  JudgedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isJudged;
  }
}

class JudgementAbility extends Ability {
  JudgementAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.judgement;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(JudgedEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return !target.hasEffect(StatusEffectType.wasJudged);
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
  void usePostEffect(GameModel game, List<Player> affected) {}
}

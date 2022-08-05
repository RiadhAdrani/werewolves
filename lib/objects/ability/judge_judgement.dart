import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/judge_effect.dart';

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
    target.addStatusEffect(JudgedStatusEffect(owner));
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

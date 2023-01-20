// ignore: implementation_imports
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Witch extends RoleSingular {
  Witch(super.player) {
    callingPriority = witchPriority;
    abilities = [CurseAbility(this), ReviveAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.witch;
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

    final wounded = getPlayersWithFatalEffect(usePlayerExtractor(roles));

    if (wounded.isEmpty) {
      output.add('(Nobody) was killed.');
    } else {
      output.add('(${wounded.map((p) => p.name).join(', ')}) was killed.');
    }

    output
        .addAll(['Would you like to revive?', 'Do you want to curse someone?']);

    return output;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  bool shouldBeCalledAgainBeforeNightEnd(List<Role> roles, int turn) {
    return isFatallyAffected && hasUnusedAbilityOfType(AbilityId.revive);
  }
}

class CursedEffect extends Effect {
  CursedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isCursed;
  }
}

class RevivedEffect extends Effect {
  RevivedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isRevived;
  }
}

class CurseAbility extends Ability {
  CurseAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.curse;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(CursedEffect(owner));
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

class ReviveAbility extends Ability {
  ReviveAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.revive;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.removeFatalEffects([]);
    target.addEffect(RevivedEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target.hasFatalEffect;
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

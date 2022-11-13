// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Witch extends RoleSingular {
  Witch(super.player) {
    id = RoleId.witch;
    callingPriority = witchPriority;
    abilities = [CurseAbility(this), ReviveAbility(this)];
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
    final output = <String>[];

    final wounded = game.getPlayersWithFatalEffects();

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
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

class CurseEffect extends Effect {
  CurseEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isCursed;
  }
}

class ReviveEffect extends Effect {
  ReviveEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isRevived;
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
    target.addEffect(CurseEffect(owner));
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
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was cursed.';

    return '${targets[0].name} has been cursed.';
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
    target.addEffect(ReviveEffect(owner));
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
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was revived.';

    return '${targets[0].name} has been revived.';
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

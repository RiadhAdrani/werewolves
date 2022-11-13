// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Shepherd extends RoleSingular {
  Shepherd(super.player) {
    id = RoleId.shepherd;
    callingPriority = shepherdCallPriority;
    abilities = [ShepherdAbility(this)];
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
    var maybeAbility = getAbilityOfType(AbilityId.sheeps);

    if (maybeAbility == null) {
      return false;
    } else {
      return maybeAbility.targetCount > 0;
    }
  }

  @override
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    return ['Pick a target to send the sheeps to.'];
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

class SheepEffect extends Effect {
  SheepEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.hasSheep;
  }
}

class ShepherdAbility extends Ability {
  ShepherdAbility(Role owner) {
    super.targetCount = 2;
    super.id = AbilityId.sheeps;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(SheepEffect(owner));
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
    return targetCount > 0;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    return 'Sheep(s) sent.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return targetCount > 0;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

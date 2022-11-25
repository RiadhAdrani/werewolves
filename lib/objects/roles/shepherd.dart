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
    callingPriority = shepherdPriority;
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
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
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

class HasSheepEffect extends Effect {
  HasSheepEffect(Role source) {
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
    target.addEffect(HasSheepEffect(owner));
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
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return targetCount > 0;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

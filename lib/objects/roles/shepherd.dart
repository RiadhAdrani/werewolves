// ignore: implementation_imports
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Shepherd extends RoleSingular {
  Shepherd(super.player) {
    callingPriority = shepherdPriority;
    abilities = [ShepherdAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.shepherd;
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
}

class HasSheepEffect extends Effect {
  HasSheepEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.hasSheep;
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
  bool isTarget(Player target, int turn) {
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

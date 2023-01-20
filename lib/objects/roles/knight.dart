// ignore: implementation_imports
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Knight extends RoleSingular {
  Knight(super.player) {
    callingPriority = knightPriority;
    abilities = [CounterAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.knight;
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return controller.hasFatalEffect;
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
    if (controller.hasFatalEffect) {
      return [
        'A player dared to strike you during the night!',
        'Choose a target to counter this attack and redirect it towards him.'
      ];
    }

    return [];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  bool shouldBeCalledAgainBeforeNightEnd(List<Role> roles, int turn) {
    return isFatallyAffected && hasUnusedAbilityOfType(AbilityId.counter);
  }
}

class CounteredEffect extends Effect {
  CounteredEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isCountered;
  }
}

class CounterAbility extends Ability {
  CounterAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.counter;
    super.type = AbilityType.passive;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    (owner.controller as Player).removeFatalEffects([]);
    target.addEffect(CounteredEffect(owner));
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
    return (owner.controller as Player).hasFatalEffect;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return owner.isFatallyAffected;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

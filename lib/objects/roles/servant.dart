// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class Servant extends RoleSingular {
  Servant(super.player) {
    id = RoleId.servant;
    callingPriority = servantCallPriority;
    abilities = [ServantAbility(this)];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
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
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return [
      'The servant shall choose a target.',
      'If the chosen player dies, the servant takes his role.'
    ];
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return player.hasEffect(StatusEffectType.isServing) == false;
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }
}

class ServeEffect extends StatusEffect {
  ServeEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.isServed;
  }
}

class ServingEffect extends StatusEffect {
  ServingEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.isServing;
  }
}

class ServantAbility extends Ability {
  ServantAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.serve;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    (owner.player as Player).addStatusEffect(ServingEffect(owner));
    target.addStatusEffect(ServeEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target != owner.player;
  }

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    return 'The servant is bound successfully.';
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.player as Player).hasEffect(StatusEffectType.isServing);
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {}
}

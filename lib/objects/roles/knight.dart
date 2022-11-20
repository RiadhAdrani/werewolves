// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Knight extends RoleSingular {
  Knight(super.player) {
    id = RoleId.knight;
    callingPriority = knightPriority;
    abilities = [CounterAbility(this)];

    onCreated();
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return player.hasFatalEffect;
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
    if (player.hasFatalEffect) {
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
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

class CounterEffect extends Effect {
  CounterEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isCountered;
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
    (owner.player as Player).removeFatalEffects([]);
    target.addEffect(CounterEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target != owner.player;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return (owner.player as Player).hasFatalEffect;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was designed to take the fatal blow.';

    return '${targets[0].name} has been killed.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return owner.playerIsFatallyWounded();
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

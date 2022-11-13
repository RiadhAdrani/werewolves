import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class GarrulousWolf extends RoleSingular {
  GarrulousWolf(super.player) {
    id = RoleId.garrulousWolf;
    callingPriority = garrulousWolfPriority;
    isWolf = true;
    super.abilities = [GarrulousAbility(this)];
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return false;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    return [
      'The narrator should give you a word that you must include in your speech during the day phase. (Use The "Write" button to communicate the word.)',
      'In case you did not say the word, you will be eliminated from the game.'
    ];
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.wolves;
  }

  @override
  bool shouldBeCalledAtNight(Game game) {
    return true;
  }
}

class GarrulousEffect extends Effect {
  GarrulousEffect(Role source) {
    this.source = source;
    permanent = true;
    type = EffectId.shouldSayTheWord;
  }
}

class GarrulousAbility extends Ability {
  GarrulousAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.word;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(GarrulousEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target == owner.player;
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
    return 'The Garrulous wolf knows his word.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

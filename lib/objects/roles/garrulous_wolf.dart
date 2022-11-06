import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class GarrulousWolf extends RoleSingular {
  GarrulousWolf(super.player) {
    id = RoleId.garrulousWolf;
    callingPriority = garrulousWolfCallPriority;
    isWolf = true;
    super.abilities = [GarrulousAbility(this)];
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
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
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
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
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }
}

class GarrulousEffect extends StatusEffect {
  GarrulousEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.shouldSayTheWord;
  }
}

class GarrulousAbility extends Ability {
  GarrulousAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.word;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(GarrulousEffect(owner));
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
  void usePostEffect(GameModel game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

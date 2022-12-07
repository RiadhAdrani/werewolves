import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/objects/roles/werewolf.dart';

class GarrulousWolf extends Werewolf {
  final List<String> _previousWords = [];
  String? _currentWord;

  GarrulousWolf(super.player) {
    callingPriority = garrulousWolfPriority;
    super.abilities = [GarrulousAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.garrulousWolf;
  }

  String get word {
    return _currentWord ?? '';
  }

  List<String> get previousWords {
    return _previousWords;
  }

  bool isWordValid(String word) {
    return word.trim().isNotEmpty &&
        ![..._previousWords, _currentWord].contains(word.trim());
  }

  void setWord(String word) {
    if (_currentWord != null) {
      _previousWords.add(_currentWord!);
    }

    _currentWord = word.trim();
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
    return true;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
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
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return true;
  }
}

class HasWordEffect extends Effect {
  HasWordEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.hasWord;
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
    target.addEffect(HasWordEffect(owner));
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
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

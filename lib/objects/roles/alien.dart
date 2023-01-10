import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';

class Alien extends RoleSingular {
  Alien(super.player) {
    callingPriority = alienPriority;

    super.abilities = [AlienCallSignAbility(this), GuessAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.alien;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return true;
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return true;
  }

  @override
  bool canUseSignWithNarrator() {
    return true;
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return ["Pick a callsign."];
  }

  @override
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return !controller.hasEffect(EffectId.hasCallsign);
  }

  static RoleId resolveAlienGuessPossibility(RoleId id) {
    switch (id) {
      case RoleId.protector:
        return id;
      case RoleId.witch:
        return id;
      case RoleId.seer:
        return id;
      case RoleId.knight:
        return id;
      case RoleId.hunter:
        return id;
      case RoleId.captain:
        return id;
      case RoleId.villager:
        return id;
      case RoleId.servant:
        return id;
      case RoleId.judge:
        return id;
      case RoleId.shepherd:
        return id;
      case RoleId.alien:
        return id;

      case RoleId.werewolf:
      case RoleId.fatherOfWolves:
      case RoleId.wolfpack:
      case RoleId.blackWolf:
      case RoleId.garrulousWolf:
        return RoleId.werewolf;
    }
  }

  static bool resolveAlienGuess(Player player, RoleId role) {
    return resolveAlienGuessPossibility(role) ==
        resolveAlienGuessPossibility(player.mainRole.id);
  }

  static dynamic getCorrectlyGuessedRoles(List<AlienGuessItem> items) {
    List<Player> players = [];

    for (AlienGuessItem item in items) {
      if (item.selected == true && item.guess != null) {
        if (resolveAlienGuess(item.player, item.guess!)) {
          players.add(item.player);
        } else {
          return false;
        }
      }
    }

    return players;
  }
}

class GuessAbility extends Ability {
  GuessAbility(Role owner) {
    super.targetCount = infinite;
    super.id = AbilityId.guess;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.day;
    super.ui = AbilityUI.alien;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(GuessedByAlienEffect(owner));
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
    return true;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

class GuessedByAlienEffect extends Effect {
  GuessedByAlienEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isGuessedByAlien;
  }
}

class AlienCallSignAbility extends Ability {
  AlienCallSignAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.callsign;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(HasCallSignEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target == owner.controller;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.controller as Player).hasEffect(EffectId.hasCallsign) &&
        !(owner.controller as Player).hasFatalEffect;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'Alien did not give his signal';

    return '${targets[0].name} has given his call sign.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return !(owner.controller as Player).hasEffect(EffectId.hasCallsign) &&
        !(owner.controller as Player).hasFatalEffect;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

class AlienGuessItem {
  Player player;
  bool selected = false;
  RoleId? guess;

  AlienGuessItem(this.player);
}

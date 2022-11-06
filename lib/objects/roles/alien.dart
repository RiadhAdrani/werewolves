import 'package:flutter/material.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/roles.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/alien_callsign.dart';
import 'package:werewolves/objects/ability/alien_guess.dart';

class Alien extends RoleSingular {
  Alien(super.player) {
    id = RoleId.alien;
    callingPriority = alienCallPriority;

    super.abilities = [AlienCallSignAbility(this), GuessAbility(this)];
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
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
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return ["Pick a callsign."];
  }

  @override
  Teams getSupposedInitialTeam() {
    return Teams.alien;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return !player.hasEffect(StatusEffectType.hasCallsign);
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
        return id;
      case RoleId.fatherOfWolves:
        return RoleId.werewolf;
      case RoleId.wolfpack:
        return RoleId.werewolf;
      case RoleId.blackWolf:
        return RoleId.werewolf;
      case RoleId.garrulousWolf:
        return RoleId.werewolf;
    }
  }

  static bool resolveAlienGuess(Player player, RoleId role) {
    Role mainRole = player.getMainRole();

    return resolveAlienGuessPossibility(role) == resolveAlienGuessPossibility(mainRole.id);
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

class AlienGuessItem {
  Player player;
  bool selected = false;
  RoleId? guess;

  AlienGuessItem(this.player);
}

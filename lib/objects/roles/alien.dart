import 'package:flutter/material.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/constants/teams.dart';
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
}

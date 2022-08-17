import 'package:flutter/material.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/black_mute.dart';

class BlackWolf extends RoleSingular {
  BlackWolf(super.player) {
    id = RoleId.blackWolf;
    callingPriority = blackWolfCallPriority;

    isWolf = true;

    super.abilities = [MuteAbility(this)];
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
    return ["Choose a player to mute"];
  }

  @override
  Teams getSupposedInitialTeam() {
    return Teams.wolves;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }
}
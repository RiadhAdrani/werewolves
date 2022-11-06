// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/roles.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role_group.dart';
import 'package:werewolves/objects/ability/wolfpack_devour.dart';

class Wolfpack extends RoleGroup {
  Wolfpack(super.player) {
    id = RoleId.wolfpack;
    callingPriority = wolfpackCallPriority;
    abilities = [DevourAbility(this)];
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
  bool shouldBeCalledAtNight(GameModel game) {
    return hasAtLeastOneSurvivingMember();
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return ['Assembe wolfpack.', 'Choose your victim.'];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Teams getSupposedInitialTeam() {
    return Teams.wolves;
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }

  /// Check if the team of the player should be changed to wolves
  /// when he is infected.
  static bool shouldJoinWolfpackUponInfection(Player player) {
    RoleId mainRole = player.getMainRole().id;

    switch (mainRole) {
      case RoleId.protector:
      case RoleId.werewolf:
      case RoleId.fatherOfWolves:
      case RoleId.witch:
      case RoleId.seer:
      case RoleId.knight:
      case RoleId.hunter:
      case RoleId.captain:
      case RoleId.villager:
      case RoleId.wolfpack:
      case RoleId.servant:
      case RoleId.judge:
      case RoleId.blackWolf:
      case RoleId.garrulousWolf:
      case RoleId.shepherd:
        return true;
      case RoleId.alien:
        return false;
    }
  }
}

// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role_single.dart';

class Villager extends RoleSingular {
  Villager(super.player) {
    isUnique = false;
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
  bool shouldBeCalledAtNight(GameModel game) {
    return false;
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    return [];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Teams getSupposedInitialTeam() {
    return Teams.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    return false;
  }
}

// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/witch_curse.dart';
import 'package:werewolves/objects/ability/witch_revive.dart';

class Witch extends RoleSingular {
  Witch(super.player) {
    id = RoleId.witch;
    callingPriority = witchCallPriority;
    abilities = [CurseAbility(this), ReviveAbility(this)];
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
    return true;
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    final output = <String>[];

    final wounded = game.getPlayersWithFatalEffects();

    if (wounded.isEmpty) {
      output.add('(Nobody) was killed.');
    } else {
      output.add('(${wounded.map((e) => e.getName()).join(', ')}) was killed.');
    }

    output.addAll([
      'Would you like to revive?',
      'Do you want to curse someone?'
    ]);

    return output;
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

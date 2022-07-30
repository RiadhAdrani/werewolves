import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/captain_execute.dart';
import 'package:werewolves/objects/ability/captain_inherit.dart';
import 'package:werewolves/objects/ability/captain_substitue.dart';
import 'package:werewolves/objects/ability/captain_talker.dart';

class Captain extends RoleSingular {
  Captain(super.player) {
    id = RoleId.captain;
    callingPriority = captainCallPriority;

    super.abilities = [
      ExecuteAbility(this),
      SubstitueAbility(this),
      TalkerAbility(this),
      InheritAbility(this)
    ];
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

    if (player.hasFatalEffect()) {
      output.add(
          'You are dead, choose another fellow player to inherit your capitaincy.');
    }

    output.add('Choose a player whom will start the discussion.');

    return output;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return true;
  }

  @override
  Teams getSupposedInitialTeam() {
    return Teams.village;
  }
}

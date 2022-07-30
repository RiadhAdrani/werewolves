import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role_single.dart';

class Werewolf extends RoleSingular {
  Werewolf(super.player) {
    id = RoleId.werewolves;
    isWolf = true;

    /// TODO : check for these cases when adding new roles
    /// A servant with [love effect] transformed into a werewolf should not change its team.

    if (player.roles.length == 1) {
      player.team = Teams.wolves;
    }
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
    return Teams.wolves;
  }
}

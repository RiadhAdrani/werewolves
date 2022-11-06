import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/utils/check_game_balance.dart';
import 'package:werewolves/utils/extract_players_from_role_list.dart';

dynamic checkListIsValid(List<Role> roles) {
  if (roles.length < 7) {
    return "Player count is too short to start a game. Try adding more roles to reach at least 7 players.";
  }

  dynamic balanced = checkTeamsAreBalanced(extractPlayersList(roles), roles);

  if (balanced != true) {
    return "Game is not balanced, ${getTeamName(balanced)} team is already winning.";
  }

  return true;
}

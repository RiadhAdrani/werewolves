import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/role.dart';

dynamic calculateNewTeamForServant(Role newRole) {
  /// TODO: if servant is in the lovers team, it should not change its team
  /// TODO: if the new role is a solo role, change it to the new role.
  
  if (newRole.isWolf) return Teams.wolves;

  return false;
}

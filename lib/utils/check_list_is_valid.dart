import 'package:werewolves/models/role.dart';

dynamic checkListIsValid(List<Role> list) {
  if (list.length < 7) return "Player count is too short to start a game. Try adding more roles to reach at least 7 players.";

  return true;
}

import 'package:werewolves/models/player.dart';

int getWolfTeamCount(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (player.team == Team.wolves) {
      sum++;
    }
  }

  return sum;
}

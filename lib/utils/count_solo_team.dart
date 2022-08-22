import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/player.dart';

int getSoloTeamsCount(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (![Teams.village, Teams.wolves].contains(player.team)) {
      sum++;
    }
  }

  return sum;
}

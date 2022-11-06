import 'package:werewolves/models/player.dart';

int getSoloTeamsCount(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (![Team.village, Team.wolves].contains(player.team)) {
      sum++;
    }
  }

  return sum;
}

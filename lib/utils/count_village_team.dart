import 'package:werewolves/models/player.dart';

int getVillageTeamCount(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (player.team == Team.village) {
      sum++;
    }
  }

  return sum;
}

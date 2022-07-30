import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/player.dart';

int getVillageTeamCount(List<Player> players) {
    int sum = 0;

    for (var player in players) {
      if (player.team == Teams.village) {
        sum++;
      }
    }

    return sum;
  }
import 'package:werewolves/models/player.dart';

String getTeamName(Team team) {
  switch (team) {
    case Team.village:
      return 'Village';
    case Team.wolves:
      return 'Wolves';
    case Team.cupid:
      return 'Lovers';
    case Team.alien:
      return 'Alien';
    case Team.equality:
      return 'Null';
  }
}

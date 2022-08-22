import 'package:werewolves/constants/teams.dart';

String getTeamName(Teams team) {
  switch (team) {
    case Teams.village:
      return 'Village';
    case Teams.wolves:
      return 'Wolves';
    case Teams.cupid:
      return 'Lovers';
    case Teams.alien:
      return 'Alien';
    case Teams.equality:
      return 'Null';
  }
}

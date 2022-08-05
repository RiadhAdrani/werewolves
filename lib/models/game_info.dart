import 'package:werewolves/constants/game_states.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/transformers/strings/get_role_name.dart';

class GameInformation {
  late final String _text;
  late final GameState _period;
  late final int _turn;

  String getText() {
    return _text;
  }

  GameState getPeriod() {
    return _period;
  }

  int getTurn() {
    return _turn;
  }

  GameInformation(this._text, this._turn, this._period);

  static GameInformation deathInformation(
      Player player, GameState period, int turn) {
    return GameInformation('${player.getName()} died.', turn, period);
  }

  static GameInformation talkInformation(
      Player player, GameState period, int turn) {
    return GameInformation(
        '${player.getName()} starts the discussion.', turn, period);
  }

  static GameInformation clairvoyanceInformation(
      RoleId role, GameState period, int turn) {
    return GameInformation('The seer saw : ${getRoleName(role)}', turn, period);
  }

  static GameInformation servantInformation(
      RoleId role, GameState period, int turn) {
    return GameInformation(
        'The servant became ${getRoleName(role)}.', turn, period);
  }

  static GameInformation judgeInformation(Player player, int turn) {
    return GameInformation(
        'The Judge portected ${player.getName()}.', turn, GameState.night);
  }
}

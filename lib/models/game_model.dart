import 'package:flutter/cupertino.dart';
import 'package:werewolves/constants/game_states.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/game/make_roles_from_initial_list.dart';
import 'package:werewolves/widgets/game/game_day_view.dart';
import 'package:werewolves/widgets/game/game_init_view.dart';
import 'package:werewolves/widgets/game/game_night_view.dart';

class GameModel extends ChangeNotifier {
  final List<Role> _roles = [];
  GameState _state = GameState.empty;

  int _currentIndex = 0;
  int _currentTurn = 0;

  Widget viewToDisplay(BuildContext context) {
    switch (_state) {
      case GameState.empty:
        return const Text('Loading...');
      case GameState.initialized:
        return gameInitView(this,context);
      case GameState.night:
        return gameNightView(this,context);
      case GameState.day:
        return gameDayView(this,context);
    }
  }

  void init(List<Role> list) {
    _gameInit(list);
  }

  void startTurn() {
    _gameTransitionToNight();
  }

  void next() {
    if (_state == GameState.night) {
      _setNextIndex();
    }
  }

  Role? getCurrent() {
    if (_state != GameState.night) return null;

    return _roles[_currentIndex];
  }

  int getCurrentTurn() {
    return _currentTurn;
  }

  void _setNextIndex() {
    if (_roles.isEmpty) return;

    int next = 999999;

    for (var role in _roles) {
      if (role.callingPriority > _roles[_currentIndex].callingPriority &&
          role.callingPriority > -1 &&
          role.shouldBeCalledAtNight(this) &&
          role.callingPriority < next) {
        next = role.callingPriority;
      }
    }

    var probablyNextIndex =
        _roles.indexWhere((element) => element.callingPriority == next);

    if (probablyNextIndex != -1) {
      _currentIndex = probablyNextIndex;
      notifyListeners();
    } else {
      _gameTransitionToDay();
    }
  }

  void _initCurrentIndex() {
    if (_roles.isEmpty) return;

    var min = 9999;

    for (var role in _roles) {
      if (role.callingPriority < min && role.callingPriority > -1) {
        min = role.callingPriority;
      }
    }

    _currentIndex =
        _roles.indexWhere((element) => element.callingPriority == min);
  }

  void _initRoles(List<Role> list) {
    _roles.addAll(makeRolesFromInitialList(list));
  }

  void _gameInit(List<Role> list) {
    _initRoles(list);
    _initCurrentIndex();

    _state = GameState.initialized;

    notifyListeners();
  }

  void _gameTransitionToNight() {
    _currentTurn = _currentTurn + 1;
    _state = GameState.night;

    _initCurrentIndex();

    notifyListeners();
  }

  void _gameTransitionToDay() {
    _state = GameState.day;

    notifyListeners();
  }
}

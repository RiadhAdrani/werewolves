import 'package:flutter/cupertino.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/game/resolve_alien_guess.dart';

class UseAlienAbilityModel extends ChangeNotifier {
  late List<AlienGuessItem> items;
  late List<RoleId> possibleGuesses = [];

  UseAlienAbilityModel(List<Player> players, List<Role> remainingRoles) {
    for (var element in remainingRoles) {
      RoleId expected = resolveAlienGuessPossibility(element.id);

      if (!possibleGuesses.contains(expected)) {
        possibleGuesses.add(expected);
      }
    }

    items = players.map((player) => AlienGuessItem(player)).toList();
  }

  void toggleSelected(AlienGuessItem item) {
    if (item.guess == null) {
      return;
    }

    item.selected = !item.selected;

    notifyListeners();
  }

  void changeGuess(AlienGuessItem item, RoleId? guess) {
    item.guess = guess;
    item.selected = guess != null;

    notifyListeners();
  }

  dynamic getCorrectlyGuessedRoles() {
    List<Player> players = [];

    for (AlienGuessItem item in items) {
      if (item.selected == true && item.guess != null) {
        if (resolveAlienGuess(item.player, item.guess!)) {
          players.add(item.player);
        } else {
          return false;
        }
      }
    }

    return players;
  }
}

class AlienGuessItem {
  Player player;
  bool selected = false;
  RoleId? guess;

  AlienGuessItem(this.player);
}

import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/alien.dart';

class UseAlienAbilityModel extends ChangeNotifier {
  late List<AlienGuessItem> items;
  late List<RoleId> possibleGuesses = [];

  UseAlienAbilityModel(List<Player> players, List<Role> remainingRoles) {
    for (var element in remainingRoles) {
      RoleId expected = Alien.resolveAlienGuessPossibility(element.id);

      if (!possibleGuesses.contains(expected)) {
        possibleGuesses.add(expected);
      }
    }

    items = players.map((player) => AlienGuessItem(player)).toList();
  }

  void toggle(AlienGuessItem item) {
    if (item.guess == null) {
      return;
    }

    item.selected = !item.selected;

    notifyListeners();
  }

  void change(AlienGuessItem item, RoleId? guess) {
    item.guess = guess;
    item.selected = guess != null;

    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';

class UseAbilityModel extends ChangeNotifier {
  final List<Player> selected = [];
  late final Ability ability;

  UseAbilityModel(this.ability);

  void add(Player target) {
    if (ability.targetCount == selected.length) {
      selected.removeAt(0);
    }

    selected.add(target);
  }

  void remove(Player target) {
    selected.remove(target);
  }

  bool isSelected(Player target) {
    return selected.contains(target);
  }

  void toggle(Player target) {
    if (isSelected(target)) {
      remove(target);
    } else {
      add(target);
    }

    notifyListeners();
  }
}

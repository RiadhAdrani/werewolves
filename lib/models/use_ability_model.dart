import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';

class UseAbilityModel extends ChangeNotifier {
  final List<Player> _selected = [];
  late final Ability _ability;

  UseAbilityModel(this._ability);

  List<Player> getSelected() {
    return _selected;
  }

  void _addToSelected(Player target) {
    if (_ability.targetCount == _selected.length) {
      _selected.removeAt(0);
    }

    _selected.add(target);
  }

  void _removeFromSelected(Player target) {
    _selected.remove(target);
  }

  bool isSelected(Player target) {
    return _selected.contains(target);
  }

  void toggleSelected(Player target) {
    if (isSelected(target)) {
      _removeFromSelected(target);
    } else {
      _addToSelected(target);
    }

    notifyListeners();
  }
}

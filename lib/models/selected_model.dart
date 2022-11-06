import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';

class SelectedModel extends ChangeNotifier {
  final List<Role> _items = [];
  final List<Role> _available = makeAvailableList();

  SelectedModel();

  UnmodifiableListView<Role> get items => UnmodifiableListView(_items);

  UnmodifiableListView<Role> get available => UnmodifiableListView(_available);

  void add(Role item) {
    _items.add(item);
  }

  void remove(Role item) {
    _items.remove(item);
  }

  List<Role> generateList() {
    return makeListFromId(_items.map((role) => role.id).toList());
  }

  bool isSelected(Role item) {
    return countNumber(item.id) > 0;
  }

  int countNumber(RoleId id) {
    int count = 0;

    for (var role in _items) {
      if (role.id == id) count++;
    }

    return count;
  }

  void addCount(Role role) {
    if (role.isUnique) return;

    if (role.id == RoleId.villager) {
      add(Villager(Player('dummy_villager')));
    }

    if (role.id == RoleId.werewolf) {
      add(Werewolf(Player('dummy_wolf')));
    }

    notifyListeners();
  }

  void toggleSelected(Role item) {
    if (isSelected(item)) {
      if (item.isUnique) {
        remove(item);
      } else {
        if (countNumber(item.id) > 0) {
          for (var role in _items) {
            if (role.id == item.id) {
              /// Remove one instance;
              _items.remove(role);
              break;
            }
          }
        }
      }
    } else {
      add(item);
    }

    notifyListeners();
  }
}

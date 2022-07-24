import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/make_available_list.dart';

class SelectedModel extends ChangeNotifier {
  final List<Role> _items = [];
  final List<Role> _available = makeAvailableList();

  SelectedModel() {
    // getCurrentlySelectedRoles();
  }

  UnmodifiableListView<Role> get items => UnmodifiableListView(_items);

  UnmodifiableListView<Role> get available => UnmodifiableListView(_available);

  void add(Role item) {
    _items.add(item);
  }

  void remove(Role item) {
    _items.remove(item);
  }

  bool isSelected(Role item) {
    try {
      _items.firstWhere((element) => element.instanceId == item.instanceId);
      return true;
    } catch (e) {
      return false;
    }
  }

  void toggleSelected(Role item) {
    if (isSelected(item)) {
      remove(item);
    } else {
      add(item);
    }

    notifyListeners();
  }
}

import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/role.dart';

class SelectedModel extends ChangeNotifier {
  final List<RoleId> _items = [];

  SelectedModel();

  List<RoleId> get items => _items;

  UnmodifiableListView<RoleId> get available =>
      UnmodifiableListView(RoleId.values.where((id) => useRole(id).pickable));

  bool isPicked(RoleId item) {
    return _items.contains(item);
  }

  int getCount(RoleId item) {
    return _items.where((id) => id == item).length;
  }

  void add(RoleId item) {
    var role = useRole(item);

    if (getCount(item) == 0 || !role.isUnique) {
      _items.add(item);

      notifyListeners();
    }
  }

  void remove(RoleId role) {
    _items.remove(role);

    notifyListeners();
  }

  List<Role> generateList() {
    return createSingularRolesListFromId(
      _items.map((id) => id).toList(),
    );
  }
}

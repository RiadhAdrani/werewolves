import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/utils.dart';

class DistributedRole {
  RoleId id;
  String player;

  DistributedRole(this.id, this.player);
}

class DistributionModel extends ChangeNotifier {
  List<RoleId> roles;

  List<RoleId> pool = [];
  List<DistributedRole> distributed = [];

  DistributionModel(this.roles) {
    pool = [...roles];
  }

  bool get done {
    return roles.isEmpty && distributed.length == pool.length;
  }

  bool get canPick {
    return roles.isNotEmpty;
  }

  int get picked {
    return distributed.length;
  }

  int get size {
    return pool.length;
  }

  int? pick() {
    if (!canPick) return null;

    return Random().nextInt(roles.length);
  }

  bool assign(int index, String name) {
    if (index < 0 || index >= roles.length) {
      return false;
    }

    if (name.trim().isEmpty) {
      return false;
    }

    bool exist = distributed.any((element) =>
        element.player.trim().toLowerCase() == name.toLowerCase().trim());

    if (exist) {
      return false;
    }

    distributed.add(DistributedRole(roles[index], name));
    roles.removeAt(index);

    notifyListeners();
    return true;
  }

  void reset() {
    roles = [...pool];
    distributed = [];

    notifyListeners();
  }

  void autofill() {
    while (roles.isNotEmpty) {
      RoleId id = roles[0];
      String name = '${useRole(id).name} (${useId()})';
      assign(0, name);
    }

    notifyListeners();
  }
}

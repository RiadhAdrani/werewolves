// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';

class Villager extends RoleSingular {
  Villager(super.player);

  @override
  bool canUseAbilitiesDuringNight() {
    return false;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return false;
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return [];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

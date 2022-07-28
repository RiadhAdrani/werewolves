import 'package:uuid/uuid.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

const uuid = Uuid();

class Player {
  late String name;

  bool isAlive = true;
  Teams team = Teams.solo;
  String id = uuid.v4();
  List<StatusEffect> effects = [];
  List<Role> roles = [];

  Player(this.name);

  String getName() {
    return name;
  }

  void changeTeam(Teams newTeam) {
    team = newTeam;
  }

  void addStatusEffect(StatusEffect effect) {
    effects.add(effect);
  }

  void removeStatusEffect(StatusEffectType effect) {
    effects = effects.where((element) => element.type != effect).toList();
  }

  void removeFatalEffects(List<StatusEffectType> exception) {
    final newList = <StatusEffect>[];

    for (var effect in effects) {
      if (exception.contains(effect.type) ||
          !fatalStatusEffects.contains(effect.type)) {
        newList.add(effect);
      }
    }

    effects = newList;
  }

  bool hasEffect(StatusEffectType effect) {
    for (var e in effects) {
      if (e.type == effect) return true;
    }

    return false;
  }

  bool hasFatalEffect() {
    for (var e in effects) {
      if (fatalStatusEffects.contains(e.type)) return true;
    }

    return false;
  }

  bool hasRole(RoleId id) {
    for (var role in roles) {
      if (role.id == id) return true;
    }

    return false;
  }

  bool hasGroupRole() {
    for (var role in roles) {
      if (role.isGroupRole) return true;
    }

    return false;
  }

  bool hasWolfRole() {
    for (var role in roles) {
      if (role.isWolf) return true;
    }

    return false;
  }

  bool isDead() {
    return !isAlive;
  }
}

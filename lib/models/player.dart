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

  Player.nameIdTeam(this.name, this.id, this.team);

  void addStatusEffect(StatusEffect effect) {
    effects.add(effect);
  }

  void removeStatusEffect(StatusEffectType effect) {
    effects = effects.where((element) => element.type != effect).toList();
  }

  void removeFatalEffects(List<StatusEffectType> exception) {
    for (var effect in effects) {
      if (!exception.contains(effect.type) &&
          fatalStatusEffects.contains(effect.type)) {
        effects.remove(effect);
      }
    }
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

  bool hasWolfRole() {
    for (var role in roles) {
      if (role.isWolf) return true;
    }

    return false;
  }
}

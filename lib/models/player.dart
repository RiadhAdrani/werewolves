import 'package:uuid/uuid.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/status_effect.dart';

const uuid = Uuid();

class Player {
  late String name;

  bool isAlive = true;
  Teams team = Teams.solo;
  String id = uuid.v4();
  List<StatusEffect> effects = [];

  Player(this.name);
  Player.nameIdTeam(this.name, this.id, this.team);

  void addStatusEffect(StatusEffect effect) {
    effects.add(effect);
  }

  void removeStatusEffect(StatusEffectType effect) {
    effects = effects.where((element) => element.type != effect).toList();
  }

  bool hasEffect(StatusEffectType effect) {
    for (var e in effects) {
      if (e.type == effect) return true;
    }

    return false;
  }

  bool hasFatalEffect(){
    for (var e in effects) {
      if (fatalStatusEffects.contains(e.type)) return true;
    }

    return false;
  }
}

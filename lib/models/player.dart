import 'package:uuid/uuid.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/status_effect.dart';

const uuid = Uuid();

class Player {
  late String name;
  
  Teams team = Teams.solo;
  String id = uuid.v4();
  List<StatusEffect> effects = [];
  Player(this.name);

  void addStatusEffect(StatusEffect effect) {
    effects.add(effect);
  }

  void removeStatusEffect(StatusEffects effect) {
    effects = effects.where((element) => element.type != effect).toList();
  }
}

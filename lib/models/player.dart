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

  Player.nameIdTeam(this.name, this.id, this.team);

  void addStatusEffect(StatusEffect effect) {
    effects.add(effect);
  }

  void removeStatusEffect(StatusEffects effect) {
    effects = effects.where((element) => element.type != effect).toList();
  }

  Player.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    team = json['team'];
    id = json['id'];
  }

  toJson() {
    return {
      name,team,id
    };
  }
}

import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class InfectStatusEffect extends StatusEffect {
  InfectStatusEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.isInfected;
  }
}

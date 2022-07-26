import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class CounterStatusEffect extends StatusEffect {
  CounterStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isCountered;
  }
}

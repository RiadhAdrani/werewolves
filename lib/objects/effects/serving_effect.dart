import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class ServingStatusEffect extends StatusEffect{
  ServingStatusEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.isServing;
  }
}
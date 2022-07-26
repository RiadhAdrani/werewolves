import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class ClairvoyanceStatusEffect extends StatusEffect {
  ClairvoyanceStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isSeen;
  }
}

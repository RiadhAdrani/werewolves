import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class SubstitueStatusEffect extends StatusEffect {
  SubstitueStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isSubstitue;
  }
}

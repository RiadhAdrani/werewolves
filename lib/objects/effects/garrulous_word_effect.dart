import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class GarrulousWordStatusEffect extends StatusEffect {
  GarrulousWordStatusEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.shouldSayTheWord;
  }
}

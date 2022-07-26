import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class DevourStatusEffect extends StatusEffect {
  DevourStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isDevoured;
  }
}

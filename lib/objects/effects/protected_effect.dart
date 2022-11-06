import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class ProtectStatusEffect extends StatusEffect {
  ProtectStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isProtected;
  }
}

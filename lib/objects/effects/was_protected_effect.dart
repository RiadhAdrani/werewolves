import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class WasProtectedStatusEffect extends StatusEffect {
  WasProtectedStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.wasProtected;
  }
}

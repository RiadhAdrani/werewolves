import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class ServeStatusEffect extends StatusEffect {
  ServeStatusEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.isServed;
  }
}

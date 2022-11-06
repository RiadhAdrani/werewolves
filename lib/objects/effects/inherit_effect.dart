import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class InheritCaptaincyStatusEffect extends StatusEffect {
  InheritCaptaincyStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.hasInheritedCaptaincy;
  }
}

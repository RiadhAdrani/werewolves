import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class ReviveStatusEffect extends StatusEffect {
  ReviveStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isRevived;
  }
}

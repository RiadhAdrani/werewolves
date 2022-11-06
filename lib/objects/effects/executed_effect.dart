import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class ExecutedStatusEffect extends StatusEffect {
  ExecutedStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isExecuted;
  }
}

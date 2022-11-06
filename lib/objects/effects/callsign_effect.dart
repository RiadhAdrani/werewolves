import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class CallSignEffect extends StatusEffect {
  CallSignEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.hasCallsign;
  }
}

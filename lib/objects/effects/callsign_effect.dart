import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class CallsignStatusEffect extends StatusEffect {
  CallsignStatusEffect(Role source) {
    this.source = source;
    permanent = true;
    type = StatusEffectType.hasCallsign;
  }
}

import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class WasJudgedStatusEffect extends StatusEffect {
  WasJudgedStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.wasJudged;
  }
}

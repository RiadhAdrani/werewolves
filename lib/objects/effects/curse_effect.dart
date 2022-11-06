import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class CurseStatusEffect extends StatusEffect {
  CurseStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isCursed;
  }
}

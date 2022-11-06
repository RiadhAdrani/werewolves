import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class SheepStatusEffect extends StatusEffect {
  SheepStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.hasSheep;
  }
}

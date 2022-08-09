import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class WasMutedStatusEffect extends StatusEffect {
  WasMutedStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.wasMuted;
  }
}

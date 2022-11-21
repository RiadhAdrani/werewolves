import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class HasCallSignEffect extends Effect {
  HasCallSignEffect(Role source) {
    this.source = source;
    permanent = true;
    type = EffectId.hasCallsign;
  }
}

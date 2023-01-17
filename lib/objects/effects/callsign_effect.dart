import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class HasCallSignEffect extends Effect {
  HasCallSignEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.hasCallsign;
  }

  @override
  bool get isPermanent {
    return true;
  }
}

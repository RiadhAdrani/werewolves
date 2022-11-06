import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class CallSignEffect extends Effect {
  CallSignEffect(Role source) {
    this.source = source;
    permanent = true;
    type = EffectId.hasCallsign;
  }
}

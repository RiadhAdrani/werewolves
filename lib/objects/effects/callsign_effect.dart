import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class CallSignEffect extends Effect {
  CallSignEffect(Role source) {
    this.source = source;
    permanent = true;
    type = EffectId.hasCallsign;
  }
}

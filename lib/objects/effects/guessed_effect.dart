import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';

class GuessedStatusEffect extends StatusEffect {
  GuessedStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = StatusEffectType.isGuessed;
  }
}

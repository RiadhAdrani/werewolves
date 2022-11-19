import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class GuessedStatusEffect extends Effect {
  GuessedStatusEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isGuessedByAlien;
  }
}

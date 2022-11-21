import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class GuessedByAlienEffect extends Effect {
  GuessedByAlienEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isGuessedByAlien;
  }
}

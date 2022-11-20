import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class GuessEffect extends Effect {
  GuessEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isGuessedByAlien;
  }
}

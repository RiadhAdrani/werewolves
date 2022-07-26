import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';

class Villager extends RoleSingular {
  Villager(super.player);

  @override
  bool canUseAbilities() {
    return false;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return false;
  }
}

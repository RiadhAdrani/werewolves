import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';

class Werewolf extends RoleSingular {
  Werewolf(super.player) {
    id = RoleId.werewolves;
    isWolf = true;
  }

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

import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/knight_counter.dart';

class Knight extends RoleSingular {
  Knight(super.player) {
    id = RoleId.knight;
    callingPriority = knightCallPriority;
    abilities = [CounterAbility(this)];
  }

  @override
  bool canUseAbilities() {
    return player.hasFatalEffect();
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    if (player.hasFatalEffect()) {
      return [
        'A player dared to strike you during the night!',
        'Choose a target to counter this attack and redirect it towards him.'
      ];
    }

    return [];
  }
}

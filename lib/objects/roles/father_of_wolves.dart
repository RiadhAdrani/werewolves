import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/father_infect.dart';

class FatherOfWolves extends RoleSingular {
  FatherOfWolves(super.player) {
    id = RoleId.fatherOfWolves;
    isWolf = true;
    callingPriority = fatherOfWolvesCallPriority;
    abilities = [InfectAbility(this)];
  }

  @override
  bool canUseAbilities() {
    return true;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return game.getCurrentTurn() > 1;
  }
}

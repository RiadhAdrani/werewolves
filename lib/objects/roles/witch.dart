import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/witch_curse.dart';
import 'package:werewolves/objects/ability/witch_revive.dart';

class Witch extends RoleSingular {
  Witch(super.player) {
    id = RoleId.witch;
    callingPriority = witchCallPriority;
    abilities = [CurseAbility(this),ReviveAbility(this)];
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
    return true;
  }
}

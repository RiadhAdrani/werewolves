import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/seer_clairvoyance.dart';

class Seer extends RoleSingular {
  Seer(super.player) {
    id = RoleId.seer;
    callingPriority = seerCallPriority;
    abilities = [ClairvoyanceAbility(this)];
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

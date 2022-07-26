import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_group.dart';
import 'package:werewolves/objects/ability/wolfpack_devour.dart';

class Wolfpack extends RoleGroup {
  Wolfpack(super.player) {
    id = RoleId.wolfpack;
    callingPriority = wolfpackCallPriority;
    abilities = [DevourAbility(this)];
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
    return hasAtLeastOneSurvivingMember();
  }
}

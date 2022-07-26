import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/captain_execute.dart';
import 'package:werewolves/objects/ability/captain_inherit.dart';
import 'package:werewolves/objects/ability/captain_substitue.dart';
import 'package:werewolves/objects/ability/captain_talker.dart';

class Captain extends RoleSingular {
  Captain(super.player) {
    id = RoleId.captain;
    callingPriority = captainCallPriority;

    super.abilities = [
      ExecuteAbility(this),
      SubstitueAbility(this),
      TalkerAbility(this),
      InheritAbility(this)
    ];
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

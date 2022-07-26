import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/protector_protect.dart';

class Protector extends RoleSingular {
  Protector(super.player) {
    id = RoleId.protector;
    callingPriority = protectorCallPriority;
    abilities = [ProtectAbility(this)];
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }

  @override
  bool canUseAbilities() {
    return true;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }
}

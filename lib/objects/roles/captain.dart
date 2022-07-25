import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_single.dart';

class Captain extends RoleSingular {
  Captain(super.player) {
    id = RoleId.captain;
    callingPriority = captainCallPriority;

    super.abilities = [];
  }
}

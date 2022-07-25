import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_single.dart';

class Seer extends RoleSingular {
  Seer(super.player) {
    id = RoleId.seer;
    callingPriority = seerCallPriority;
  }
}

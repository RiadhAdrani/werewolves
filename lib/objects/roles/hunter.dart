import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_single.dart';

class Hunter extends RoleSingular {
  Hunter(super.player) {
    id = RoleId.hunter;
    callingPriority = hunterCallPriority;
  }
}

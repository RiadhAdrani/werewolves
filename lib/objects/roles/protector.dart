import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_single.dart';

class Protector extends RoleSingular {
  Protector(super.player) {
    id = RoleId.protector;
    callingPriority = protectorCallPriority;
  }
}

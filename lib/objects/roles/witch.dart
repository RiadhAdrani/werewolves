import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_single.dart';

class Witch extends RoleSingular {
  Witch(super.player) {
    id = RoleId.witch;
    callingPriority = witchCallPriority;
  }
}

import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_group.dart';

class Wolfpack extends RoleGroup {
  Wolfpack(super.player) {
    id = RoleId.wolfpack;
    callingPriority = wolfpackCallPriority;
  }
}

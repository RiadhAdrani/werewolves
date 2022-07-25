import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_single.dart';

class Knight extends RoleSingular {
  Knight(super.player) {
    id = RoleId.knight;
    callingPriority = knightCallPriority;
  }
}

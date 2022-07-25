import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/role_single.dart';

class Werewolf extends RoleSingular {
  Werewolf(super.player) {
    id = RoleId.werewolves;
    isWolf = true;
  }
}

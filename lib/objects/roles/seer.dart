import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Seer extends Role<Player> {
  Seer(super.player) {
    id = RoleId.seer;
  }
}

import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Protector extends Role<Player> {
  Protector(super.player) {
    id = RoleId.protector;
  }
}

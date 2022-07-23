import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Witch extends Role<Player> {
  Witch(super.player) {
    id = RoleId.witch;
  }
}

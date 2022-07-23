import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Knight extends Role<Player> {
  Knight(super.player) {
    id = RoleId.knight;
  }
}

import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Hunter extends Role<Player> {
  Hunter(super.player) {
    id = RoleId.hunter;
    super.abilities = [];
  }
}

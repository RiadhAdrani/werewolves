import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Captain extends Role<Player> {
  Captain(super.player) {
    id = RoleId.captain;
    callingPriority = 10000;

    super.abilities = [];
  }
}

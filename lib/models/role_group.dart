import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class RoleGroup extends Role<List<Player>> {
  RoleGroup(super.player) {
    isGroupRole = true;
  }

  @override
  String getPlayerName() {
    if (player.isEmpty) return 'There is no one in this group.';

    return player.map((player) => player.name).join(", ");
  }
}

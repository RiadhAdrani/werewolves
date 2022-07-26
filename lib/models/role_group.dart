import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

abstract class RoleGroup extends Role<List<Player>> {
  RoleGroup(super.player) {
    isGroupRole = true;
  }

  @override
  String getPlayerName() {
    if (player.isEmpty) return 'There is no one in this group.';

    return player.map((player) => player.name).join(", ");
  }

  bool hasAtLeastOneSurvivingMember() {
    for (var member in player) {
      if (member.isAlive) return true;
    }

    return false;
  }
}

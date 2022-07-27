import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

abstract class RoleGroup extends Role<List<Player>> {
  RoleGroup(super.player) {
    isGroupRole = true;

    for (var member in player) {
      member.roles.add(this);
    }
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

  @override
  bool playerIsDead() {
    return !hasAtLeastOneSurvivingMember();
  }

  @override
  bool playerIsFatallyWounded() {
    bool result = true;

    for (var member in player) {
      if (!member.hasFatalEffect()) {
        return false;
      }
    }

    return result;
  }

  @override
  void setPlayer(List<Player> player) {
    this.player = player;

    for (var member in this.player) {
      member.roles.add(this);
    }
  }
}

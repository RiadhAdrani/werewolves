import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

abstract class RoleSingular extends Role<Player> {
  RoleSingular(super.player) {
    player.roles.add(this);
  }

  @override
  String getPlayerName() {
    return player.name;
  }

  @override
  void setPlayer(Player player) {
    this.player = player;

    this.player.roles.add(this);
  }

  @override
  bool isObsolete() {
    return !player.isAlive;
  }

  @override
  bool playerIsFatallyWounded() {
    return player.hasFatalEffect();
  }
}

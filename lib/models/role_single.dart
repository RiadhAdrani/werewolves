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
    return player.isAlive == false;
  }

  @override
  bool playerIsFatallyWounded() {
    return player.hasFatalEffect();
  }

  @override
  void setObsolete() {
    var deadPlayer =
        Player('this_is_a_dummy_dead_player_should_not_appear_in_game');

    deadPlayer.isAlive = false;

    player = deadPlayer;
  }
}

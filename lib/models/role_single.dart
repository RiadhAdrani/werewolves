import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

abstract class RoleSingular extends Role<Player> {
  RoleSingular(super.player);

  @override
  String getPlayerName() {
    return player.name;
  }
}

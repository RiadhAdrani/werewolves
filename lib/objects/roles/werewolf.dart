import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Werewolf extends Role<Player> {
  Werewolf(super.player) {
    id = RoleId.werewolves;
  }
}

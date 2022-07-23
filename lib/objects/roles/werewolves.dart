import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Werewolves extends Role<List<Player>> {
  Werewolves(super.player) {
    id = RoleId.werewolves;
  }
}

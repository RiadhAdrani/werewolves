import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class FatherOfWolves extends Role<Player> {
  FatherOfWolves(super.player) {
    id = RoleId.fatherOfWolves;
  }
}

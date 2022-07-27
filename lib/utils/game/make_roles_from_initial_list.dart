import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

List<Role> makeRolesFromInitialList(List<Role> input) {
  // role Groups to be added
  var wolfpack = <Player>[];

  // output
  var output = <Role>[];

  for (var role in input) {
    if (role.isWolf) {
      wolfpack.add(role.player as Player);
    }

    if (!role.isGroup()) {
      output.add(role);
    }
  }

  output.add(Wolfpack(wolfpack));

  return output;
}

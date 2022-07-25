import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

List<Role> makeRolesFromInitialList(List<Role> input) {
  // role Groups to be added
  var wolfpack = Wolfpack([]);

  // output
  var output = <Role>[];

  for (var element in input) {
    if (element.isWolf) {
      wolfpack.player.add(element.player as Player);
    }

    if (!element.isGroupRole){
      output.add(element);
    } 
  }

  output.add(wolfpack);

  return output;
}

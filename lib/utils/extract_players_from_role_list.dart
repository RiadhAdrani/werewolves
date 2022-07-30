import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

List<Player> extractPlayersList(List<Role> roles) {
    List<Player> output = [];

    for (var role in roles) {
      if (!role.isGroup()) {
        role.player as Player;
        if (!output.contains(role.player)) {
          if (!(role.player as Player).isDead()) {
            output.add(role.player);
          }
        }
      }
    }

    return output;
  }
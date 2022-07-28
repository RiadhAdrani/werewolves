import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/villager.dart';

Role resolveSeenRole(Player player) {
  if (player.roles.isEmpty) return Villager(player);

  if (player.roles.length == 2) {

    /// player cannot have 2 group roles,
    /// it is impossible due to the fact 
    /// that a singular role has been assigned to the player

    // TODO: check cupidon lovers.

    /// any, wolfpack -> any
    /// any, lovers -> any;
    if (player.hasGroupRole()) {
      for (var role in player.roles) {
        if (!role.isGroupRole) return role;
      }
    }

    /// we assume that the player has 2 singular roles.
    /// any, captain -> any
    if (player.hasRole(RoleId.captain)) {
      for (var role in player.roles) {
        if (role.id != RoleId.captain) return role;
      }
    }
  }


  if (player.roles.length > 2) {

    // TODO: check for other possibilities

    /// we check for any role that is not captain, or a group role.
    for (var role in player.roles) {
        if (role.id != RoleId.captain && !role.isGroupRole) return role;
      }
  }

  return player.roles[0];
}

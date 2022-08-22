import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

RoleId resolveAlienGuessPossibility(RoleId id) {
  switch (id) {
    case RoleId.protector:
      return id;
    case RoleId.witch:
      return id;
    case RoleId.seer:
      return id;
    case RoleId.knight:
      return id;
    case RoleId.hunter:
      return id;
    case RoleId.captain:
      return id;
    case RoleId.villager:
      return id;
    case RoleId.servant:
      return id;
    case RoleId.judge:
      return id;
    case RoleId.shepherd:
      return id;
    case RoleId.alien:
      return id;

    case RoleId.werewolf:
      return id;
    case RoleId.fatherOfWolves:
      return RoleId.werewolf;
    case RoleId.wolfpack:
      return RoleId.werewolf;
    case RoleId.blackWolf:
      return RoleId.werewolf;
    case RoleId.garrulousWolf:
      return RoleId.werewolf;
  }
}

bool resolveAlienGuess(Player player, RoleId role) {
  Role mainRole = player.getMainRole();

  return resolveAlienGuessPossibility(role) == resolveAlienGuessPossibility(mainRole.id);
}

import 'package:werewolves/models/ability.dart';
import 'package:werewolves/constants/roles.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/count_solo_team.dart';
import 'package:werewolves/utils/count_village_team.dart';
import 'package:werewolves/utils/count_wolf_team.dart';

dynamic checkTeamsAreBalanced(List<Player> players, List<Role> roles) {
  int wolvesCount = getWolfTeamCount(players);
  int villagersCount = getVillageTeamCount(players);
  int solosCount = getSoloTeamsCount(players);

  Role? alien = getRoleInGame(RoleId.alien, roles);

  if (players.isEmpty) {
    return Team.equality;
  }

  /// In case only solos remained
  if (solosCount == players.length) {
    return Team.equality;
  }

  /// Alien Winning condition
  /// The alien should be the only one remaining, or with a villager.
  if (players.length <= 2 &&
      alien != null &&
      wolvesCount == 0 &&
      solosCount == 1) {
    return Team.alien;
  }

  /// Villager
  /// The village win if there is no werewolf remaining.
  if (wolvesCount == 0) {
    return Team.village;
  }

  if (villagersCount == wolvesCount) {
    Role? protector = getRoleInGame(RoleId.protector, roles);
    Role? witch = getRoleInGame(RoleId.witch, roles);
    Role? knight = getRoleInGame(RoleId.knight, roles);

    bool protectorCanWinIt =
        protector != null && protector.player.team == Team.village;

    bool witchCanWinIt = (witch != null &&
        witch.player.team == Team.village &&
        (witch.hasUnusedAbility(AbilityId.curse) ||
            witch.hasUnusedAbility(AbilityId.revive)));

    bool knightCanWinIt = (knight != null &&
        knight.player.team == Team.village &&
        knight.hasUnusedAbility(AbilityId.counter));

    bool continuable = protectorCanWinIt || witchCanWinIt || knightCanWinIt;

    if (!continuable) {
      return Team.wolves;
    }
  }

  if (villagersCount < wolvesCount) {
    return Team.wolves;
  }

  return true;
}

Role? getRoleInGame(RoleId id, List<Role> roles) {
  for (var role in roles) {
    if (role.id == id && !role.isObsolete()) {
      return role;
    }
  }

  return null;
}

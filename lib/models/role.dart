import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/objects/roles/alien.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/garrulous_wolf.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/servant.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';
import 'package:werewolves/utils/utils.dart';

enum RoleId {
  protector,
  werewolf,
  fatherOfWolves,
  witch,
  seer,
  knight,
  hunter,
  captain,
  villager,
  wolfpack,
  servant,
  judge,
  blackWolf,
  garrulousWolf,
  shepherd,
  alien
}

const servantPriority = 500;
const protectorPriority = 1000;
const wolfpackPriority = 2000;
const fatherOfWolvesPriority = 3000;
const blackWolfPriority = 3500;
const garrulousWolfPriority = 3700;
const witchPriority = 4000;
const seerPriority = 5000;
const shepherdPriority = 5500;
const knightPriority = 6000;
const hunterPriority = 7000;
const alienPriority = 7200;
const judgePriority = 7500;
const captainPriority = 8000;

abstract class Role<T> {
  late T player;

  String instanceId = useId();
  int callingPriority = -1;
  List<Ability> abilities = [];
  bool isGroupRole = false;

  Role(this.player);

  RoleId get id {
    return RoleId.villager;
  }

  bool get isWolf {
    return false;
  }

  T getPlayer() {
    return player;
  }

  bool get isUnique {
    return useRole(id).isUnique;
  }

  /// Get the name of the role
  String get name {
    return getRoleName(id);
  }

  /// Return the icon path in assets
  String get icon {
    return getRoleIconPath(id);
  }

  /// Check if the role is meant to be treated as a group.
  bool get isGroup {
    return isGroupRole;
  }

  /// Get role description
  String get description {
    return getRoleDescription(id);
  }

  /// Return the first ability of the given type if it exists.
  Ability? getAbilityOfType(AbilityId ability) {
    for (int i = 0; i < abilities.length; i++) {
      if (abilities[i].id == ability) {
        return abilities[i];
      }
    }

    return null;
  }

  /// Return if the role has a certain ability by its `id`.
  bool hasAbilityOfType(AbilityId id) {
    for (Ability ability in abilities) {
      if (ability.id == id) {
        return true;
      }
    }

    return false;
  }

  bool hasUnusedAbilityOfType(AbilityId id) {
    for (Ability ability in abilities) {
      if (ability.id == id && ability.useCount != AbilityUseCount.none) {
        return true;
      }
    }

    return false;
  }

  /// Should the role be called during the night.
  bool shouldBeCalledAtNight(List<Role> roles, int turn);

  /// Can the role use its abilities
  bool canUseAbilitiesDuringNight();

  /// Can the role use its abilities
  bool canUseAbilitiesDuringDay();

  /// Can the role use signs to communicate with the narrator during the day.
  bool canUseSignWithNarrator();

  /// Get the name of the player that will be displayed.
  String getPlayerName();

  /// Override the associated player.
  void setPlayer(T player);

  /// Check if the player `isAlive` equals false.
  /// `isAlive` is updated between phases, and not during the night,
  /// except by a dead captain.
  bool isObsolete();

  /// Check if the player has been affected by a fatal status effect.
  /// Used to check is primarily dead during the night.
  bool playerIsFatallyWounded();

  /// Get the informations that the role needs to know.
  List<String> getInformations(List<Role> roles);

  /// Get the instructions ,advices and tips for the narrator.
  List<String> getAdvices(List<Role> roles);

  /// Return the supposed initial role team.
  /// This is used when distributing roles
  /// and programmatically assign initial team
  /// for players.
  Team getSupposedInitialTeam();

  /// Effects that will be executed
  /// before the call of the player.
  ///
  /// Used mainly with a dead captain
  /// chosen by the servant.
  bool beforeCallEffect(BuildContext context, Game gameModel);

  /// Force the role into an obsolete state.
  void setObsolete();
}

abstract class RoleSingular extends Role<Player> {
  RoleSingular(super.player);

  @override
  String getPlayerName() {
    return player.name;
  }

  @override
  void setPlayer(Player player) {
    this.player.removeRole(id);

    if (player.hasRole(id)) {
      throw 'Player already have this role';
    }

    player.roles.add(this);

    this.player = player;
  }

  @override
  bool isObsolete() {
    return player.isAlive == false;
  }

  @override
  bool playerIsFatallyWounded() {
    return player.hasFatalEffect;
  }

  @override
  void setObsolete() {
    var deadPlayer =
        Player('this_is_a_dummy_dead_player_should_not_appear_in_game');

    deadPlayer.isAlive = false;

    player = deadPlayer;
  }
}

abstract class RoleGroup extends Role<List<Player>> {
  RoleGroup(super.player) {
    isGroupRole = true;
  }

  List<Player> getCurrentPlayers() {
    return player.where((player) => !player.isDead).toList();
  }

  @override
  String getPlayerName() {
    if (player.isEmpty) return 'There is no one in this group.';

    return getCurrentPlayers().map((player) => player.name).join(" | ");
  }

  bool hasAtLeastOneSurvivingMember() {
    for (var member in player) {
      if (member.isAlive) return true;
    }

    return false;
  }

  @override
  bool isObsolete() {
    return !hasAtLeastOneSurvivingMember();
  }

  @override
  bool playerIsFatallyWounded() {
    bool result = true;

    for (var member in player) {
      if (!member.hasFatalEffect) {
        return false;
      }
    }

    return result;
  }

  @override
  void setPlayer(List<Player> player) {
    while (this.player.isNotEmpty) {
      this.player[0].removeRole(id);
    }

    for (var member in player) {
      if (member.hasRole(id)) {
        throw 'Player already have this role !';
      } else {
        member.addRole(this);
      }
    }

    this.player = player;
  }

  @override
  void setObsolete() {
    player = [];
  }
}

class RoleHelperObject {
  late String name;
  late String description;
  late String iconFile;
  late Role Function(List<Player>) createRole;
  late bool isUnique;

  Role create(List<Player> players) {
    Role role = createRole(players);

    for (var player in players) {
      player.addRole(role);
    }

    return role;
  }

  RoleHelperObject({
    required this.name,
    required this.description,
    required this.iconFile,
    required this.createRole,
    required this.isUnique,
  });

  String base(String icon) {
    return 'assets/$icon.png';
  }

  String get icon {
    return base(iconFile);
  }
}

RoleHelperObject useRole(RoleId id) {
  switch (id) {
    case RoleId.protector:
      return RoleHelperObject(
          name: 'Protector',
          description: 'No description',
          iconFile: 'protector',
          createRole: (players) => Protector(players[0]),
          isUnique: true);
    case RoleId.werewolf:
      return RoleHelperObject(
          name: 'Werewolf',
          description: 'No description',
          iconFile: 'werewolf',
          createRole: (players) => Werewolf(players[0]),
          isUnique: false);
    case RoleId.fatherOfWolves:
      return RoleHelperObject(
          name: 'Father of Wolves',
          description: 'No description',
          iconFile: 'father_wolf',
          createRole: (players) => FatherOfWolves(players[0]),
          isUnique: true);
    case RoleId.witch:
      return RoleHelperObject(
          name: 'Witch',
          description: 'No description',
          iconFile: 'witch',
          createRole: (players) => Witch(players[0]),
          isUnique: true);
    case RoleId.seer:
      return RoleHelperObject(
          name: 'Seer',
          description: 'No description',
          iconFile: 'seer',
          createRole: (players) => Seer(players[0]),
          isUnique: true);
    case RoleId.knight:
      return RoleHelperObject(
          name: 'Knight',
          description: 'No description',
          iconFile: 'knight',
          createRole: (players) => Knight(players[0]),
          isUnique: true);
    case RoleId.hunter:
      return RoleHelperObject(
          name: 'Hunter',
          description: 'No description',
          iconFile: 'hunter',
          createRole: (players) => Hunter(players[0]),
          isUnique: true);
    case RoleId.captain:
      return RoleHelperObject(
          name: 'Captain',
          description: 'No description',
          iconFile: 'captain',
          createRole: (players) => Captain(players[0]),
          isUnique: true);
    case RoleId.villager:
      return RoleHelperObject(
          name: 'Villager',
          description: 'No description',
          iconFile: 'simple_villager',
          createRole: (players) => Villager(players[0]),
          isUnique: false);
    case RoleId.wolfpack:
      return RoleHelperObject(
          name: 'Wolfpack',
          description: 'No description',
          iconFile: 'werewolf',
          createRole: (players) => Wolfpack(players),
          isUnique: true);
    case RoleId.servant:
      return RoleHelperObject(
          name: 'Servant',
          description: 'No description',
          iconFile: 'simple_villager',
          createRole: (players) => Servant(players[0]),
          isUnique: true);
    case RoleId.judge:
      return RoleHelperObject(
          name: 'Judge',
          description: 'No description',
          iconFile: 'simple_villager',
          createRole: (players) => Judge(players[0]),
          isUnique: true);
    case RoleId.blackWolf:
      return RoleHelperObject(
          name: 'Black Wolf',
          description: 'No description',
          iconFile: 'werewolf',
          createRole: (players) => BlackWolf(players[0]),
          isUnique: true);
    case RoleId.garrulousWolf:
      return RoleHelperObject(
          name: 'Garrulous Wolf',
          description: 'No description',
          iconFile: 'werewolf',
          createRole: (players) => GarrulousWolf(players[0]),
          isUnique: true);
    case RoleId.shepherd:
      return RoleHelperObject(
          name: 'Shepherd',
          description: 'No description',
          iconFile: 'simple_villager',
          createRole: (players) => Shepherd(players[0]),
          isUnique: true);
    case RoleId.alien:
      return RoleHelperObject(
          name: 'Servant',
          description: 'No description',
          iconFile: 'simple_villager',
          createRole: (players) => Alien(players[0]),
          isUnique: true);
  }
}

List<Role> createSingularRolesListFromId(List<RoleId> listOfIds) {
  final list = <Role>[];

  Player player() => Player("dummy Player");

  for (var id in listOfIds) {
    list.add(useRole(id).create([player()]));
  }

  return list;
}

Role createRoleFromId(
  RoleId id,
  Player player,
) {
  return useRole(id).create([player]);
}

List<Role> prepareGameRolesFromPickedList(List<Role> input) {
  // TODO : add other group roles
  var wolfpack = <Player>[];

  // output
  var output = <Role>[];

  for (var role in input) {
    if (!role.isGroup) {
      if (role.isWolf) {
        wolfpack.add(role.player);
        continue;
      }

      output.add(role);
    }
  }

  if (wolfpack.isEmpty) {
    throw 'Game cannot start without a wolfpack !';
  } else {
    output.add(Wolfpack(wolfpack));
  }

  return output;
}

String getRoleDescription(RoleId id) {
  return useRole(id).description;
}

String getRoleIconPath(RoleId id) {
  return useRole(id).icon;
}

String getRoleName(RoleId id) {
  return useRole(id).name;
}

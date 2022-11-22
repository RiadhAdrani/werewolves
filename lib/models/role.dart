import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
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
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/servant.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

const uuid = Uuid();

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
  late RoleId id;

  String instanceId = uuid.v4();
  int callingPriority = -1;
  List<Ability> abilities = [];
  bool isWolf = false;
  bool isGroupRole = false;
  bool isUnique = true;

  Role(this.player);

  void onCreated();

  T getPlayer() {
    return player;
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
  bool shouldBeCalledAtNight(Game game);

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
  List<String> getInformations(Game game);

  /// Get the instructions ,advices and tips for the narrator.
  List<String> getAdvices(Game game);

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
  void onCreated() {
    setPlayer(player);
  }

  @override
  String getPlayerName() {
    return player.name;
  }

  @override
  void setPlayer(Player player) {
    if (player.hasRole(id)) {
      throw 'Player already have this role';
    }

    this.player = player;

    player.roles.add(this);
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

  @override
  void onCreated() {
    setPlayer(player);
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
    this.player = player;

    for (var member in player) {
      if (member.hasRole(id)) {
        throw 'Player already have this role !';
      } else {
        member.roles.add(this);
      }
    }
  }

  @override
  void setObsolete() {
    player = [];
  }
}

class RoleResourceObject {
  late String name;
  late String description;
  late String iconFile;
  late Role Function(List<Player>) create;

  RoleResourceObject(
    this.name,
    this.description,
    this.iconFile,
    this.create,
  );

  String base(String icon) {
    return 'assets/$icon.png';
  }

  String get icon {
    return base(iconFile);
  }
}

RoleResourceObject useRoleData(RoleId id) {
  switch (id) {
    case RoleId.protector:
      return RoleResourceObject(
        'Protector',
        'No description',
        'protector',
        (players) => Protector(players[0]),
      );
    case RoleId.werewolf:
      return RoleResourceObject(
        'Werewolf',
        'No description',
        'werewolf',
        (players) => Werewolf(players[0]),
      );
    case RoleId.fatherOfWolves:
      return RoleResourceObject(
        'Father of Wolves',
        'No description',
        'father_wolf',
        (players) => FatherOfWolves(players[0]),
      );
    case RoleId.witch:
      return RoleResourceObject(
        'Witch',
        'No description',
        'witch',
        (players) => Witch(players[0]),
      );
    case RoleId.seer:
      return RoleResourceObject(
        'Seer',
        'No description',
        'seer',
        (players) => Seer(players[0]),
      );
    case RoleId.knight:
      return RoleResourceObject(
        'Knight',
        'No description',
        'knight',
        (players) => Werewolf(players[0]),
      );
    case RoleId.hunter:
      return RoleResourceObject(
        'Hunter',
        'No description',
        'hunter',
        (players) => Hunter(players[0]),
      );
    case RoleId.captain:
      return RoleResourceObject(
        'Captain',
        'No description',
        'captain',
        (players) => Captain(players[0]),
      );
    case RoleId.villager:
      return RoleResourceObject(
        'Villager',
        'No description',
        'simple_villager',
        (players) => Villager(players[0]),
      );
    case RoleId.wolfpack:
      return RoleResourceObject(
        'Wolfpack',
        'No description',
        'werewolf',
        (players) => Wolfpack(players),
      );
    case RoleId.servant:
      return RoleResourceObject(
        'Servant',
        'No description',
        'simple_villager',
        (players) => Servant(players[0]),
      );
    case RoleId.judge:
      return RoleResourceObject(
        'Judge',
        'No description',
        'simple_villager',
        (players) => Judge(players[0]),
      );
    case RoleId.blackWolf:
      return RoleResourceObject(
        'Black Wolf',
        'No description',
        'werewolf',
        (players) => BlackWolf(players[0]),
      );
    case RoleId.garrulousWolf:
      return RoleResourceObject(
        'Garrulous Wolf',
        'No description',
        'werewolf',
        (players) => GarrulousWolf(players[0]),
      );
    case RoleId.shepherd:
      return RoleResourceObject(
        'Shepherd',
        'No description',
        'simple_villager',
        (players) => Shepherd(players[0]),
      );
    case RoleId.alien:
      return RoleResourceObject(
        'Servant',
        'No description',
        'simple_villager',
        (players) => Alien(players[0]),
      );
  }
}

List<Role> createSingularRolesListFromId(List<RoleId> listOfIds) {
  final list = <Role>[];

  Player player() => Player("dummy Player");

  for (var id in listOfIds) {
    list.add(useRoleData(id).create([player()]));
  }

  return list;
}

Role createRoleFromId(
  RoleId id,
  Player player,
) {
  return useRoleData(id).create([player]);
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
  return useRoleData(id).description;
}

String getRoleIconPath(RoleId id) {
  return useRoleData(id).icon;
}

String getRoleName(RoleId id) {
  return useRoleData(id).name;
}

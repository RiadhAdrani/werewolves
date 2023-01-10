import 'package:flutter/cupertino.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/app/assets.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/distribution.dart';
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
  late T controller;

  String instanceId = useId();
  int callingPriority = -1;
  List<Ability> abilities = [];

  Role(this.controller);

  RoleId get id {
    return RoleId.villager;
  }

  bool get callable {
    return callingPriority != -1;
  }

  bool get isWolf {
    return useRole(id).isWolf;
  }

  bool get isSolo {
    return useRole(id).isSolo;
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
    return false;
  }

  bool get isObsolete {
    return true;
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

  /// Check if the player has been affected by a fatal status effect.
  /// Used to check is primarily dead during the night.
  bool playerIsFatallyWounded();

  /// Get the informations that the role needs to know.
  List<String> getInformations(List<Role> roles);

  /// Get the instructions ,advices and tips for the narrator.
  List<String> getAdvices(List<Role> roles);

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
    return controller.name;
  }

  @override
  void setPlayer(Player player) {
    controller.removeRole(id);

    if (player.hasRole(id)) {
      throw 'Player already have this role';
    }

    player.roles.add(this);

    controller = player;
  }

  @override
  bool get isObsolete {
    return controller.isAlive == false;
  }

  @override
  bool playerIsFatallyWounded() {
    return controller.hasFatalEffect;
  }

  @override
  void setObsolete() {
    var deadPlayer =
        Player('this_is_a_dummy_dead_player_should_not_appear_in_game');

    deadPlayer.isAlive = false;

    controller = deadPlayer;
  }
}

abstract class RoleGroup extends Role<List<Player>> {
  RoleGroup(super.player);

  @override
  bool get isGroup {
    return true;
  }

  List<Player> get currentPlayers {
    return controller.where((player) => !player.isDead).toList();
  }

  @override
  String getPlayerName() {
    if (controller.isEmpty) return 'There is no one in this group.';

    return currentPlayers.map((player) => player.name).join(" | ");
  }

  bool hasAtLeastOneSurvivingMember() {
    for (var member in controller) {
      if (member.isAlive) return true;
    }

    return false;
  }

  @override
  bool get isObsolete {
    return !hasAtLeastOneSurvivingMember();
  }

  @override
  bool playerIsFatallyWounded() {
    bool result = true;

    for (var member in controller) {
      if (!member.hasFatalEffect) {
        return false;
      }
    }

    return result;
  }

  @override
  void setPlayer(List<Player> player) {
    while (controller.isNotEmpty) {
      controller[0].removeRole(id);
    }

    for (var member in player) {
      if (member.hasRole(id)) {
        throw 'Player already have this role !';
      } else {
        member.addRole(this);
      }
    }

    controller = player;
  }

  @override
  void setObsolete() {
    controller = [];
  }
}

class RoleHelperObject {
  late String name;
  late String description;
  late String iconFile;
  late Role Function(List<Player>) createRole;
  late bool isUnique;
  late bool pickable;
  late bool isWolf;
  late bool isSolo;

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
    this.pickable = true,
    this.isWolf = false,
    this.isSolo = false,
  });

  String base(String icon) {
    return Assets.icon(icon);
  }

  String get icon {
    return base(iconFile);
  }
}

RoleHelperObject useRole(RoleId id) {
  switch (id) {
    case RoleId.protector:
      return RoleHelperObject(
        name: t(LKey.protector),
        description: t(LKey.protectorDescription),
        iconFile: 'salvateur',
        createRole: (players) => Protector(players[0]),
        isUnique: true,
      );
    case RoleId.werewolf:
      return RoleHelperObject(
        name: t(LKey.werewolf),
        description: t(LKey.werewolfDescription),
        iconFile: 'loup-garou',
        createRole: (players) => Werewolf(players[0]),
        isUnique: false,
        isWolf: true,
      );
    case RoleId.fatherOfWolves:
      return RoleHelperObject(
        name: t(LKey.fatherWolf),
        description: t(LKey.fatherWolfDescription),
        iconFile: 'pere-infecte',
        createRole: (players) => FatherOfWolves(players[0]),
        isUnique: true,
        isWolf: true,
      );
    case RoleId.witch:
      return RoleHelperObject(
        name: t(LKey.witch),
        description: t(LKey.witchDescription),
        iconFile: 'sorciere',
        createRole: (players) => Witch(players[0]),
        isUnique: true,
      );
    case RoleId.seer:
      return RoleHelperObject(
        name: t(LKey.seer),
        description: t(LKey.seerDescription),
        iconFile: 'voyante',
        createRole: (players) => Seer(players[0]),
        isUnique: true,
      );
    case RoleId.knight:
      return RoleHelperObject(
        name: t(LKey.knight),
        description: t(LKey.knightDescription),
        iconFile: 'chevalier',
        createRole: (players) => Knight(players[0]),
        isUnique: true,
      );
    case RoleId.hunter:
      return RoleHelperObject(
        name: t(LKey.hunter),
        description: t(LKey.hunterDescription),
        iconFile: 'chasseur',
        createRole: (players) => Hunter(players[0]),
        isUnique: true,
      );
    case RoleId.captain:
      return RoleHelperObject(
        name: t(LKey.captain),
        description: t(LKey.captainDescription),
        iconFile: 'villageois',
        createRole: (players) => Captain(players[0]),
        isUnique: true,
      );
    case RoleId.villager:
      return RoleHelperObject(
        name: t(LKey.villager),
        description: t(LKey.villagerDescription),
        iconFile: 'villageois',
        createRole: (players) => Villager(players[0]),
        isUnique: false,
      );
    case RoleId.wolfpack:
      return RoleHelperObject(
        name: t(LKey.wolfpack),
        description: t(LKey.wolfpackDescription),
        iconFile: 'loup-garou',
        createRole: (players) => Wolfpack(players),
        isUnique: true,
        pickable: false,
      );
    case RoleId.servant:
      return RoleHelperObject(
        name: 'Servant',
        description: 'No description',
        iconFile: 'villageois',
        createRole: (players) => Servant(players[0]),
        isUnique: true,
        pickable: false,
      );
    case RoleId.judge:
      return RoleHelperObject(
        name: t(LKey.judge),
        description: t(LKey.judgeDescription),
        iconFile: 'juge',
        createRole: (players) => Judge(players[0]),
        isUnique: true,
      );
    case RoleId.blackWolf:
      return RoleHelperObject(
        name: t(LKey.blackWolf),
        description: t(LKey.blackWolfDescription),
        iconFile: 'loup-garou',
        createRole: (players) => BlackWolf(players[0]),
        isUnique: true,
        isWolf: true,
      );
    case RoleId.garrulousWolf:
      return RoleHelperObject(
        name: t(LKey.garrulousWolf),
        description: t(LKey.garrulousWolfDescription),
        iconFile: 'loup-garou',
        createRole: (players) => GarrulousWolf(players[0]),
        isUnique: true,
        isWolf: true,
      );
    case RoleId.shepherd:
      return RoleHelperObject(
        name: t(LKey.shepherd),
        description: t(LKey.shepherdDescription),
        iconFile: 'villageois',
        createRole: (players) => Shepherd(players[0]),
        isUnique: true,
      );
    case RoleId.alien:
      return RoleHelperObject(
        name: t(LKey.alien),
        description: t(LKey.alienDescription),
        iconFile: 'villageois',
        createRole: (players) => Alien(players[0]),
        isUnique: true,
        isSolo: true,
      );
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

List<Role> transformRolesFromPickedList(List<DistributedRole> input) {
  var wolfpackMembers = <Player>[];

  // output
  var output = <Role>[];

  for (var item in input) {
    var helper = useRole(item.id);

    Player player = Player(item.player);
    Role role = helper.create([player]);

    if (helper.isWolf) {
      wolfpackMembers.add(player);
    }

    output.add(role);
  }

  if (wolfpackMembers.isEmpty) {
    throw 'Game cannot start without a wolfpack !';
  } else {
    Wolfpack pack = Wolfpack(wolfpackMembers);

    for (var player in wolfpackMembers) {
      player.addRole(pack);
    }

    output.add(pack);
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

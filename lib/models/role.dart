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

class ValidationWithEffect extends Validation {
  void Function(BuildContext, Game) useEffect;

  ValidationWithEffect(super.valid, this.useEffect, {super.msg});
}

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

  /// Check if the player has been affected by a fatal status effect.
  /// Used to check is primarily dead during the night.
  bool get isFatallyAffected;

  /// Get the name of the player that will be displayed.
  String get controllerName;

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

  ValidationWithEffect onBeforeCalled(BuildContext context, Game game) {
    return ValidationWithEffect(true, (ctx, game) {});
  }

  /// Should the role be called once again before the night end.
  bool shouldBeCalledAgainBeforeNightEnd(List<Role> roles, int turn) {
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

  /// Override the associated player.
  void setPlayer(T player);

  /// Get the informations that the role needs to know.
  List<String> getInformations(List<Role> roles);

  /// Get the instructions ,advices and tips for the narrator.
  List<String> getAdvices(List<Role> roles);

  /// Force the role into an obsolete state.
  void setObsolete();
}

abstract class RoleSingular extends Role<Player> {
  RoleSingular(super.player);

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
  String get controllerName {
    return controller.name;
  }

  @override
  bool get isObsolete {
    return controller.isAlive == false;
  }

  @override
  bool get isFatallyAffected {
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
  String get controllerName {
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
  bool get isFatallyAffected {
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
    return Assets.icon(iconFile);
  }
}

RoleHelperObject useRole(RoleId id) {
  switch (id) {
    case RoleId.protector:
      return RoleHelperObject(
        name: t(LK.protector),
        description: t(LK.protectorDescription),
        iconFile: Assets.protector,
        createRole: (players) => Protector(players[0]),
        isUnique: true,
      );
    case RoleId.werewolf:
      return RoleHelperObject(
        name: t(LK.werewolf),
        description: t(LK.werewolfDescription),
        iconFile: Assets.werewolf,
        createRole: (players) => Werewolf(players[0]),
        isUnique: false,
        isWolf: true,
      );
    case RoleId.fatherOfWolves:
      return RoleHelperObject(
        name: t(LK.fatherWolf),
        description: t(LK.fatherWolfDescription),
        iconFile: Assets.fatherWolf,
        createRole: (players) => FatherOfWolves(players[0]),
        isUnique: true,
        isWolf: true,
      );
    case RoleId.witch:
      return RoleHelperObject(
        name: t(LK.witch),
        description: t(LK.witchDescription),
        iconFile: Assets.witch,
        createRole: (players) => Witch(players[0]),
        isUnique: true,
      );
    case RoleId.seer:
      return RoleHelperObject(
        name: t(LK.seer),
        description: t(LK.seerDescription),
        iconFile: Assets.seer,
        createRole: (players) => Seer(players[0]),
        isUnique: true,
      );
    case RoleId.knight:
      return RoleHelperObject(
        name: t(LK.knight),
        description: t(LK.knightDescription),
        iconFile: Assets.knight,
        createRole: (players) => Knight(players[0]),
        isUnique: true,
      );
    case RoleId.hunter:
      return RoleHelperObject(
        name: t(LK.hunter),
        description: t(LK.hunterDescription),
        iconFile: Assets.hunter,
        createRole: (players) => Hunter(players[0]),
        isUnique: true,
      );
    case RoleId.captain:
      return RoleHelperObject(
        name: t(LK.captain),
        description: t(LK.captainDescription),
        iconFile: Assets.villager,
        createRole: (players) => Captain(players[0]),
        isUnique: true,
      );
    case RoleId.villager:
      return RoleHelperObject(
        name: t(LK.villager),
        description: t(LK.villagerDescription),
        iconFile: Assets.villager,
        createRole: (players) => Villager(players[0]),
        isUnique: false,
      );
    case RoleId.wolfpack:
      return RoleHelperObject(
        name: t(LK.wolfpack),
        description: t(LK.wolfpackDescription),
        iconFile: Assets.werewolf,
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
        name: t(LK.judge),
        description: t(LK.judgeDescription),
        iconFile: Assets.judge,
        createRole: (players) => Judge(players[0]),
        isUnique: true,
      );
    case RoleId.blackWolf:
      return RoleHelperObject(
        name: t(LK.blackWolf),
        description: t(LK.blackWolfDescription),
        iconFile: Assets.werewolf,
        createRole: (players) => BlackWolf(players[0]),
        isUnique: true,
        isWolf: true,
      );
    case RoleId.garrulousWolf:
      return RoleHelperObject(
        name: t(LK.garrulousWolf),
        description: t(LK.garrulousWolfDescription),
        iconFile: Assets.werewolf,
        createRole: (players) => GarrulousWolf(players[0]),
        isUnique: true,
        isWolf: true,
      );
    case RoleId.shepherd:
      return RoleHelperObject(
        name: t(LK.shepherd),
        description: t(LK.shepherdDescription),
        iconFile: Assets.villager,
        createRole: (players) => Shepherd(players[0]),
        isUnique: true,
      );
    case RoleId.alien:
      return RoleHelperObject(
        name: t(LK.alien),
        description: t(LK.alienDescription),
        iconFile: Assets.villager,
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

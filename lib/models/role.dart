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
import 'package:werewolves/objects/roles/knight.dart';
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

const servantCallPriority = 500;
const protectorCallPriority = 1000;
const wolfpackCallPriority = 2000;
const fatherOfWolvesCallPriority = 3000;
const blackWolfCallPriority = 3500;
const garrulousWolfCallPriority = 3700;
const witchCallPriority = 4000;
const seerCallPriority = 5000;
const shepherdCallPriority = 5500;
const knightCallPriority = 6000;
const hunterCallPriority = 7000;
const alienCallPriority = 7200;
const judgeCallPriority = 7500;
const captainCallPriority = 8000;

abstract class Role<T> {
  late T player;

  RoleId id = RoleId.villager;
  String instanceId = uuid.v4();
  int callingPriority = -1;
  List<Ability> abilities = [];
  bool isWolf = false;
  bool isGroupRole = false;
  bool isUnique = true;

  Role(this.player);

  T getPlayer() {
    return player;
  }

  /// Get the name of the role
  String getName() {
    return getRoleName(id);
  }

  /// Return the icon path in assets
  String getIcon() {
    return getRoleIconPath(id);
  }

  /// Check if the role is meant to be treated as a group.
  bool isGroup() {
    return isGroupRole;
  }

  /// Get role description
  String getDescription() {
    return getRoleDescription(id);
  }

  /// Return the first ability of the given type if it exists.
  Ability? getAbilityOfType(AbilityId ability) {
    for (int i = 0; i < abilities.length; i++) {
      if (abilities[i].name == ability) {
        return abilities[i];
      }
    }

    return null;
  }

  /// Return if the role has a certain ability by its `id`.
  bool hasAbility(AbilityId id) {
    for (Ability ability in abilities) {
      if (ability.name == id) {
        return true;
      }
    }

    return false;
  }

  bool hasUnusedAbility(AbilityId id) {
    for (Ability ability in abilities) {
      if (ability.name == id && ability.useCount != AbilityUseCount.none) {
        return true;
      }
    }

    return false;
  }

  /// Should the role be called during the night.
  bool shouldBeCalledAtNight(GameModel game);

  /// Can the role use its abilities
  bool canUseAbilitiesDuringNight();

  /// Can the role use its abilities
  bool canUseAbilitiesDuringDay();

  /// Can the role use signs to communicate with the narrator during the dary.
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
  List<String> getInformations(GameModel game);

  /// Get the instructions ,advices and tips for the narrator.
  List<String> getAdvices(GameModel game);

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
  bool beforeCallEffect(BuildContext context, GameModel gameModel);

  /// Force the role into an obsolete state.
  void setObsolete();
}

abstract class RoleSingular extends Role<Player> {
  RoleSingular(super.player) {
    player.roles.add(this);
  }

  @override
  String getPlayerName() {
    return player.name;
  }

  @override
  void setPlayer(Player player) {
    this.player = player;

    this.player.roles.add(this);
  }

  @override
  bool isObsolete() {
    return player.isAlive == false;
  }

  @override
  bool playerIsFatallyWounded() {
    return player.hasFatalEffect();
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

    for (var member in player) {
      member.roles.add(this);
    }
  }

  List<Player> getCurrentPlayers() {
    return player.where((player) => !player.isDead()).toList();
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
      if (!member.hasFatalEffect()) {
        return false;
      }
    }

    return result;
  }

  @override
  void setPlayer(List<Player> player) {
    this.player = player;

    for (var member in this.player) {
      member.roles.add(this);
    }
  }

  @override
  void setObsolete() {
    player = [];
  }
}

List<Role> makeListFromId(List<RoleId> listOfIds) {
  final list = <Role>[];

  final player = Player("dummy Player");

  for (var element in listOfIds) {
    switch (element) {
      case RoleId.protector:
        list.add(Protector(player));
        break;
      case RoleId.werewolf:
        list.add(Werewolf(player));
        break;
      case RoleId.fatherOfWolves:
        list.add(FatherOfWolves(player));
        break;
      case RoleId.witch:
        list.add(Witch(player));
        break;
      case RoleId.seer:
        list.add(Seer(player));
        break;
      case RoleId.knight:
        list.add(Knight(player));
        break;
      case RoleId.hunter:
        list.add(Hunter(player));
        break;
      case RoleId.captain:
        list.add(Captain(player));
        break;
      case RoleId.villager:
        list.add(Villager(player));
        break;
      case RoleId.wolfpack:
        break;
      case RoleId.servant:
        list.add(Servant(player));
        break;
      case RoleId.judge:
        list.add(Judge(player));
        break;
      case RoleId.blackWolf:
        list.add(BlackWolf(player));
        break;
      case RoleId.garrulousWolf:
        list.add(GarrulousWolf(player));
        break;
      case RoleId.shepherd:
        list.add(Shepherd(player));
        break;
      case RoleId.alien:
        list.add(Alien(player));
        break;
    }
  }

  return list;
}

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

String getRoleDescription(RoleId role) {
  // TODO : description for roles
  return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce consectetur pulvinar enim vitae blandit. Etiam lobortis velit a risus interdum, in fermentum dui venenatis. Nunc feugiat sapien at condimentum aliquam. Donec vitae odio pharetra, malesuada mi at, aliquam ante.';
}

String getRoleIconPath(RoleId role) {
  String base(String icon) {
    return 'assets/$icon.png';
  }

  switch (role) {
    case RoleId.protector:
      return base('protector');
    case RoleId.werewolf:
      return base('werewolf');
    case RoleId.fatherOfWolves:
      return base('father_wolf');
    case RoleId.witch:
      return base('witch');
    case RoleId.seer:
      return base('seer');
    case RoleId.knight:
      return base('knight');
    case RoleId.hunter:
      return base('hunter');
    case RoleId.captain:
      return base('captain');
    case RoleId.villager:
      return base('simple_villager');
    case RoleId.wolfpack:
      return base('werewolf');
    case RoleId.servant:
      return base('simple_villager');
    case RoleId.judge:
      return base('simple_villager');
    case RoleId.blackWolf:
      return base('werewolf');
    case RoleId.garrulousWolf:
      return base('werewolf');
    case RoleId.shepherd:
      return base('simple_villager');
    case RoleId.alien:
      return base('simple_villager');
  }
}

String getRoleName(RoleId role) {
  switch (role) {
    case RoleId.protector:
      return "Protector";
    case RoleId.werewolf:
      return "Werewolf";
    case RoleId.fatherOfWolves:
      return "Father of wolves";
    case RoleId.witch:
      return "Witch";
    case RoleId.seer:
      return "Seer";
    case RoleId.knight:
      return "Knight";
    case RoleId.hunter:
      return "Hunter";
    case RoleId.captain:
      return "Captain";
    case RoleId.villager:
      return "Villager";
    case RoleId.wolfpack:
      return "Wolfpack";
    case RoleId.servant:
      return "Servant";
    case RoleId.judge:
      return "Judge";
    case RoleId.blackWolf:
      return "Black Wolf";
    case RoleId.garrulousWolf:
      return 'Garrulous Wolf';
    case RoleId.shepherd:
      return 'Shepherd';
    case RoleId.alien:
      return "Alien";
  }
}

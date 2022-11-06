import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/transformers/strings/get_role_description.dart';
import 'package:werewolves/transformers/strings/get_role_name.dart';
import 'package:werewolves/transformers/strings/get_role_icon.dart';

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

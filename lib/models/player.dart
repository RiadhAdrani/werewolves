import 'package:uuid/uuid.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/role_group.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/roles/villager.dart';

enum Team { equality, village, wolves, cupid, alien }

const uuid = Uuid();

class Player {
  late String name;

  bool isAlive = true;
  Team team = Team.village;
  String id = uuid.v4();
  List<StatusEffect> effects = [];
  List<Role> roles = [];

  Player(this.name);

  /// Return the player name.
  String getName() {
    return name;
  }

  /// Switch the current team.
  void changeTeam(Team newTeam) {
    team = newTeam;
  }

  /// Add a new status effect.
  /// Does not account for duplicate.
  void addStatusEffect(StatusEffect effect) {
    effects.add(effect);
  }

  /// Remove all status effect of the given type
  void removeEffectsOfType(StatusEffectType effect) {
    effects = effects.where((element) => element.type != effect).toList();
  }

  /// Remove all fatal effects except the given ones.
  void removeFatalEffects(List<StatusEffectType> exception) {
    final newList = <StatusEffect>[];

    for (var effect in effects) {
      if (exception.contains(effect.type) ||
          !fatalStatusEffects.contains(effect.type)) {
        newList.add(effect);
      }
    }

    effects = newList;
  }

  /// Add a role to the list of player's roles.
  /// If a role with the same id exists, the operation will exit.
  void addRole(Role newRole) {
    for (var role in roles) {
      if (role.id == newRole.id) return;
    }

    roles.add(newRole);
  }

  /// Remove all roles of the given type.
  void removeRoleOfType(RoleId id) {
    roles.removeWhere((role) {
      if (role.id == id) {
        if (role.isGroup()) {
          (role as RoleGroup)
              .player
              .removeWhere((Player player) => player.id == this.id);
        } else {
          var dummyDeadVillager = Player("this_player_name_should_not_appear");
          dummyDeadVillager.isAlive = false;

          (role as RoleSingular).player = dummyDeadVillager;
        }

        return true;
      }

      return false;
    });
  }

  /// Check if the player has a status effect.
  bool hasEffect(StatusEffectType effect) {
    for (var e in effects) {
      if (e.type == effect) return true;
    }

    return false;
  }

  /// Check if the player has a fatal effect.
  bool hasFatalEffect() {
    for (var e in effects) {
      if (fatalStatusEffects.contains(e.type)) return true;
    }

    return false;
  }

  /// Check if the player has a role of the given type.
  bool hasRole(RoleId id) {
    for (var role in roles) {
      if (role.id == id) return true;
    }

    return false;
  }

  /// Check if the player has a group role.
  bool hasGroupRole() {
    for (var role in roles) {
      if (role.isGroupRole) return true;
    }

    return false;
  }

  /// Check if the player has a wolf role.
  bool hasWolfRole() {
    for (var role in roles) {
      if (role.isWolf) return true;
    }

    return false;
  }

  /// Check if the player is obsolete and dead.
  bool isDead() {
    return !isAlive;
  }

  /// Resolve the main role of the player
  ///
  /// ### uses:
  /// - Reveal the true form for the seer.
  /// - Retrieve the main role for the alien.
  /// - Resolve the main role for the servant.
  Role getMainRole() {
    if (roles.isEmpty) return Villager(Player(''));

    if (roles.length == 2) {
      /// player cannot have 2 group roles,
      /// it is impossible due to the fact
      /// that a singular role has been assigned to the player

      // TODO: check cupidon lovers.

      /// any, wolfpack -> any
      /// any, lovers -> any;
      if (hasGroupRole()) {
        for (var role in roles) {
          if (!role.isGroupRole) return role;
        }
      }

      /// we assume that the player has 2 singular roles.
      /// any, captain -> any
      if (hasRole(RoleId.captain)) {
        for (var role in roles) {
          if (role.id != RoleId.captain) return role;
        }
      }
    }

    if (roles.length > 2) {
      // TODO: check for other possibilities

      /// we check for any role that is not captain, or a group role.
      for (var role in roles) {
        if (role.id != RoleId.captain && !role.isGroupRole) return role;
      }
    }

    return roles[0];
  }
}

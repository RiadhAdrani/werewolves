import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/utils.dart';
import 'package:werewolves/utils/errors.dart';

enum Team { equality, village, wolves, cupid, alien }

String getTeamName(Team team) {
  switch (team) {
    case Team.village:
      return 'Village';
    case Team.wolves:
      return 'Wolves';
    case Team.cupid:
      return 'Lovers';
    case Team.alien:
      return 'Alien';
    case Team.equality:
      return 'Null';
  }
}

class Player {
  late String name;

  String id = useId();

  bool isAlive = true;

  Team team = Team.village;

  List<Effect> effects = [];
  final List<Role> _roles = [];

  Player(this.name);

  List<Role> get roles {
    return _roles;
  }

  set roles(List<Role> roles) {
    throwException('Do not use setter to modify player\'s roles');
  }

  /// Check if the player has a fatal effect.
  bool get hasFatalEffect {
    for (var e in effects) {
      if (isFatalEffect(e.type)) return true;
    }

    return false;
  }

  /// Switch the current team.
  void changeTeam(Team newTeam) {
    team = newTeam;
  }

  /// Add a new status effect.
  /// Does not account for duplicate.
  void addEffect(Effect effect) {
    effects.add(effect);
  }

  /// Remove all status effect of the given type
  void removeEffectsOfType(EffectId effect) {
    effects = effects.where((element) => element.type != effect).toList();
  }

  /// Remove all fatal effects except the given ones.
  void removeFatalEffects(List<EffectId> exception) {
    final newList = <Effect>[];

    for (var effect in effects) {
      if (exception.contains(effect.type) || !isFatalEffect(effect.type)) {
        newList.add(effect);
      }
    }

    effects = newList;
  }

  /// Add a role to the list of player's roles.
  /// If a role with the same id exists, the function will throw.
  void addRole(Role newRole) {
    if (!hasRole(newRole.id)) {
      _roles.add(newRole);
    } else {
      throwException('Player already have [${newRole.id}] role.');
    }
  }

  /// Remove all roles of the given type.
  void removeRole(RoleId id) {
    _roles.removeWhere((role) {
      if (role.id == id) {
        if (role.isGroup) {
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
  bool hasEffect(EffectId effect) {
    for (var e in effects) {
      if (e.type == effect) return true;
    }

    return false;
  }

  /// Check if the player has a role of the given type.
  bool hasRole(RoleId id) {
    for (var role in _roles) {
      if (role.id == id) return true;
    }

    return false;
  }

  /// Check if the player has a group role.
  bool get hasGroupRole {
    for (var role in _roles) {
      if (role.isGroupRole) return true;
    }

    return false;
  }

  /// Check if the player has a wolf role.
  bool get hasWolfRole {
    for (var role in _roles) {
      if (role.isWolf) return true;
    }

    return false;
  }

  /// Check if the player is obsolete and dead.
  bool get isDead {
    return !isAlive;
  }

  /// Resolve the main role of the player
  ///
  /// ### uses:
  /// - Reveal the true form for the seer.
  /// - Retrieve the main role for the alien.
  /// - Resolve the main role for the servant.
  Role get mainRole {
    return resolveMainRole(this);
  }
}

Role resolveMainRole(Player player) {
  if (player._roles.isEmpty) throw 'Player has no roles !';

  if (player._roles.length == 2) {
    /// player cannot have 2 group roles,
    /// it is impossible due to the fact
    /// that a singular role has been assigned to the player

    // TODO : check cupidon lovers.

    /// any, wolfpack -> any
    /// any, lovers -> any;
    if (player.hasGroupRole) {
      for (var role in player._roles) {
        if (!role.isGroupRole) return role;
      }
    }

    /// we assume that the player has 2 singular roles.
    /// any, captain -> any
    if (player.hasRole(RoleId.captain)) {
      for (var role in player._roles) {
        if (role.id != RoleId.captain) return role;
      }
    }
  }

  if (player._roles.length > 2) {
    // TODO : check for other possibilities

    /// we check for any role that is not captain, or a group role.
    for (var role in player._roles) {
      if (role.id != RoleId.captain && !role.isGroupRole) return role;
    }
  }

  return player._roles[0];
}

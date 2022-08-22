import 'package:flutter/cupertino.dart';
import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/constants/game_states.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game_info.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/role_group.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/utils/check_game_balance.dart';
import 'package:werewolves/utils/game/calculate_new_team_for_servant.dart';
import 'package:werewolves/utils/game/clear_status_effects.dart';
import 'package:werewolves/utils/game/create_role_for_servant.dart';
import 'package:werewolves/utils/game/make_roles_from_initial_list.dart';
import 'package:werewolves/widgets/alert/game_over_alert.dart';
import 'package:werewolves/widgets/alert/game_step_alert.dart';
import 'package:werewolves/widgets/game/game_day_view.dart';
import 'package:werewolves/widgets/game/game_init_view.dart';
import 'package:werewolves/widgets/game/game_night_view.dart';
import 'package:werewolves/widgets/game/game_standard_alert.dart';
import 'package:werewolves/widgets/game/ability/use_ability.dart';
import 'package:werewolves/widgets/game/game_use_ability_done.dart';

class GameModel extends ChangeNotifier {
  final List<Role> _roles = [];
  final List<Player> _graveyard = [];
  final List<GameInformation> _infos = [];
  final List<Ability> _pendingAbilities = [];

  bool gameOver = false;

  GameState _state = GameState.empty;

  int _currentIndex = 0;
  int _currentTurn = 0;

  List<Role> getRolesForDebug() {
    return _roles;
  }

  List<Role> getPlayableRoles() {
    List<Role> output = [];

    for (Role role in _roles) {
      if (!role.isObsolete()) {
        output.add(role);
      }
    }

    return output;
  }

  /// Return the correct widget to be displayed
  /// during the current `state`.
  Widget viewToDisplay(BuildContext context) {
    switch (_state) {
      case GameState.empty:
        return const Text('Loading...');
      case GameState.initialized:
        return gameInitView(this, context);
      case GameState.night:
        return gameNightView(this, context);
      case GameState.day:
        return gameDayView(this, context);
    }
  }

  bool hasPendingAbilities() {
    return _pendingAbilities.isNotEmpty;
  }

  /// Return the current state.
  GameState getState() {
    return _state;
  }

  /// Return a list of alive players.
  /// Used for possible future role `CHAMAN`
  /// Add add them to the output list.
  List<Player> getPlayersList() {
    List<Player> output = [];

    for (var role in _roles) {
      if (!role.isGroup()) {
        role.player as Player;
        if (!output.contains(role.player)) {
          if (!(role.player as Player).isDead()) {
            output.add(role.player);
          }
        }
      }
    }

    return output;
  }

  List<Player> getDeadPlayers() {
    return _graveyard;
  }

  Role? getRole(RoleId id) {
    return getRoleInGame(id, _roles);
  }

  void addPendingAbility(Ability ability) {
    _pendingAbilities.add(ability);
  }

  /// Initialize the game.
  void init(List<Role> list) {
    _gameInit(list);
  }

  /// Use to start a new turn.
  void startTurn() {
    _gameTransitionToNight();
  }

  /// Attempt to proceed to the next role
  /// or transition into the day phase.
  void next(BuildContext context) {
    _next(context);
  }

  /// Return currently active role.
  Role? getCurrent() {
    if (_state != GameState.night) return null;

    return _roles[_currentIndex];
  }

  /// Return current turn.
  int getCurrentTurn() {
    return _currentTurn;
  }

  /// Check if the given ability is available at the current night.
  bool isAbilityAvailableAtNight(Ability ability) {
    return _isAbilityAvailableAtNight(ability);
  }

  /// Use the given ability against the provided targets.
  List<Player> useAbility(Ability ability, List<Player> targets) {
    return _useAbility(ability, targets);
  }

  /// Specific use case for [useAbility] during the night
  void useAbilitInNight(Ability ability, List<Player> targets, BuildContext context) {
    if (!ability.isForNight()) return;

    var affected = useAbility(ability, targets);

    Navigator.pop(context);

    showAbilityAppliedMessage(context, getAbilityAppliedMessage(ability, affected));
  }

  /// Specific use case for [useAbility] during the day
  void useAbilityInDay(Ability ability, List<Player> targets, BuildContext context) {
    if (!ability.isForDay()) return;

    _useAbility(ability, targets);

    Navigator.pop(context);

    notifyListeners();

    _resolveRolesInteractionsAfterAbilityUsedInDay();

    _collectPendingAbilityInDay();

    void useNext() {
      if (_pendingAbilities.isNotEmpty) {
        Ability currentPendingAbility = _pendingAbilities[0];

        _pendingAbilities.removeAt(0);

        notifyListeners();

        if (currentPendingAbility.createListOfTargetPlayers(this).isEmpty) {
          useNext();
          return;
        }

        showStepAlert(
            '${currentPendingAbility.owner.getName()} should use his ability',
            'Make sure everyone else is asleep!',
            getCurrentDaySummary().map((item) => item.getText()).toList(),
            context, () {
          showUseAbilityDialog(context, this, currentPendingAbility,
              (List<Player> currentAbilityTargets) {
            useAbilityInDay(currentPendingAbility, currentAbilityTargets, context);
          }, cancelable: false);
        });
      } else {
        // resolveEffectsAndCollectInfosOfDay(this);

        _eleminateDeadPlayers();

        notifyListeners();

        _gameOverCheck(context);
      }
    }

    useNext();
  }

  /// Return the appropriate message depending on the affected list.
  String getAbilityAppliedMessage(Ability ability, List<Player> affected) {
    return ability.onAppliedMessage(affected);
  }

  /// Add a new member to a designed role group.
  void addMemberToGroup(Player newMember, RoleId roleId) {
    _addMemberToGroup(newMember, roleId);
  }

  /// Replace the captain
  void replaceCaptainPlayer(Player player) {
    _replaceCaptainPlayer(player);
  }

  /// Add a game info
  void addGameInfo(GameInformation info) {
    _infos.add(info);
  }

  /// Return a list of players with specific effects
  List<Player> getPlayersWithStatusEffects(List<StatusEffectType> effects) {
    final output = <Player>[];

    getPlayersList().forEach((player) {
      for (var effect in effects) {
        if (!player.hasEffect(effect)) {
          return;
        }
      }

      output.add(player);
    });

    return output;
  }

  /// Return a list of players with fatal effects
  List<Player> getPlayersWithFatalEffects() {
    final output = <Player>[];

    getPlayersList().forEach((player) {
      if (player.hasFatalEffect()) {
        output.add(player);
      }
    });

    return output;
  }

  /// Return the list of the last night informations.
  List<GameInformation> getCurrentTurnSummary() {
    return _infos
        .where((item) => item.getTurn() == _currentTurn && item.getPeriod() == GameState.night)
        .toList();
  }

  /// Return the list of the current day informations.
  List<GameInformation> getCurrentDaySummary() {
    return _infos
        .where((item) => item.getTurn() == _currentTurn && item.getPeriod() == GameState.day)
        .toList();
  }

  /// Return the abilities that could be used, by sign callers or others during the day phase.
  List<Ability> getDayAbilities() {
    final output = <Ability>[];

    /// Fetch role that can use abilities and has a callsign
    for (var role in _roles) {
      if (role.isObsolete() == false &&
          role.canUseSignWithNarrator() &&
          role.canUseAbilitiesDuringDay()) {
        for (var ability in role.abilities) {
          if (ability.isForDay() && ability.isUsable()) {
            output.add(ability);
          }
        }
      }
    }

    /// Add captain execution ability
    for (var role in _roles) {
      /// We check the captain is obsolete.
      /// kinda useless but
      /// There should only one instance of captain
      /// within the list of roles.
      if (role.isObsolete() == false && role.id == RoleId.captain) {
        for (var ability in role.abilities) {
          if (ability.name == AbilityId.execute) {
            output.add(ability);
          }
        }
      }
    }

    return output;
  }

  void skipCurrentRole(BuildContext context) {
    _setNextIndex(context);
  }

  /// Perform needed tasks to transform the servant into its new role.
  /// We create a new role from the first one,
  /// and assign the [servant.player] as its player.
  void onServedDeath(Role deadRole, Function useSituationalPostEffect) {
    var servant = getRoleInGame(RoleId.servant, _roles);

    /// The servant does not exist.
    if (servant == null) {
      return;
    }

    /// The servant is dead.
    if (servant.isObsolete()) {
      return;
    }

    /// Create a new role for the servant
    var newRole = createRoleForServant(deadRole, servant.player);

    /// A possible new team
    var maybeNewTeam = calculateNewTeamForServant(newRole);

    if (maybeNewTeam is Teams && maybeNewTeam != (servant.player as Player).team) {
      (servant.player as Player).team = maybeNewTeam;
    }

    _roles.add(newRole);

    /// Remove the [serving] effect from the servant player;
    /// No need to remove the [served] effects
    /// because the dead player will be sent to the graveyard.
    (servant.player as Player).removeEffectsOfType(StatusEffectType.isServing);

    /// Add the new role to the servant player.
    (servant.player as Player).addRole(newRole);

    /// check if the new role is a wolf role.
    /// and add it to the wolfpack
    if (newRole.isWolf) {
      addMemberToGroup(servant.player, RoleId.wolfpack);
    }

    /// Remove the servant role from the servant player
    /// This should come after the player have been added to the
    /// wolfpack (if the dead role is a wolf)
    /// because we use the [servant.player] which will be overriden
    /// by [removeRoleOfType] and will be set to a dead player.
    (servant.player as Player).removeRoleOfType(RoleId.servant);

    /// Add to the game info.
    addGameInfo(GameInformation.servantInformation(deadRole.id, getState(), getCurrentTurn()));

    /// Used to perform additional processing.
    useSituationalPostEffect();
  }

  // PRIVATE METHODS
  // DO NOT EXPOSE DIRECTLY
  // --------------------------------------------------------------------------

  /// We assume that the player `hasFatalEffect()`.
  /// we set the status of survivability to false,
  /// add the player to the graveyard (r.i.p)
  /// add a game info
  void _killAndMovePlayerToGraveyard(Player player) {
    player.isAlive = false;
    _graveyard.add(player);
    addGameInfo(GameInformation.deathInformation(player, _state, _currentTurn));
  }

  /// Perform mass murder on the souls of the already dead players.
  /// Should be used on the list of alive players.
  ///
  /// uses `GameModel._killAndMovePlayerToGraveyard()`.
  void _eleminateDeadPlayers() {
    getPlayersList().forEach((player) {
      if (player.hasFatalEffect()) {
        _killAndMovePlayerToGraveyard(player);
      }
    });
  }

  /// Perform after night processes of
  /// resolving status effects
  /// and eleminating dead souls.
  /// When everything is done, we transition into the day phase.
  void _performPostNightProcessing(BuildContext context) {
    resolveEffectsAndCollectInfosOfNight(this);
    _eleminateDeadPlayers();

    _gameOverCheck(context);

    _gameTransitionToDay();
  }

  /// Check if all unskippable abilities have been used by the current player.
  /// Some abilities are mandatory for a healthy game progression.
  ///
  /// `Hunter` should use his `hunt` ability when he is fatally wounded.
  ///
  /// `Protector` should use his `shield` every turn.
  bool _checkAllUnskippableAbilitiesUse() {
    for (var ability in getCurrent()!.abilities) {
      if (ability.wasUsedInCurrentTurn(_currentTurn) == false &&
          ability.isUnskippable() &&
          ability.createListOfTargetPlayers(this).isNotEmpty) {
        return false;
      }
    }

    return true;
  }

  /// Try to find the appropriate index of the next role.
  /// If no role was found with the `probablyNextIndex`,
  /// it means, in theory, that we exhausted all possible roles
  /// and so we perform night processing
  /// which will transition the game into the day phase.
  void _setNextIndex(BuildContext context) {
    if (_roles.isEmpty) return;

    int next = 999999;

    for (var role in _roles) {
      if (role.callingPriority > _roles[_currentIndex].callingPriority &&
          role.callingPriority > -1 &&
          role.callingPriority < next &&
          role.shouldBeCalledAtNight(this) &&
          role.isObsolete() == false) {
        next = role.callingPriority;
      }
    }

    var probablyNextIndex = _roles.indexWhere((element) => element.callingPriority == next);

    if (probablyNextIndex != -1) {
      _currentIndex = probablyNextIndex;

      getCurrent()!.beforeCallEffect(context, this);

      notifyListeners();
    } else {
      _performPostNightProcessing(context);
    }
  }

  /// Find the index of the first role that should start the night.
  void _initCurrentIndex() {
    if (_roles.isEmpty) return;

    var min = 999999;

    for (var role in _roles) {
      if (role.callingPriority < min &&
          role.callingPriority > -1 &&
          role.shouldBeCalledAtNight(this) &&
          role.isObsolete() == false) {
        min = role.callingPriority;
      }
    }

    _currentIndex = _roles.indexWhere((element) => element.callingPriority == min);
  }

  /// Create appropriate `RoleGroups` and override the current list of roles.
  void _initRoles(List<Role> list) {
    _roles.addAll(makeRolesFromInitialList(list));
  }

  /// Internal function exposed by `init()`.
  /// prepare roles by adding `GroupRoles`
  /// and setting the correct selection index.
  void _gameInit(List<Role> list) {
    _initRoles(list);
    _initCurrentIndex();

    _state = GameState.initialized;

    notifyListeners();
  }

  /// Start a new turn and transition into the night.
  /// Increment the current turn
  /// and initialize the current index.
  void _gameTransitionToNight() {
    _removeObsoleteRoles();

    _currentTurn = _currentTurn + 1;
    _state = GameState.night;

    _initCurrentIndex();

    notifyListeners();
  }

  /// Transition into the day phase.
  void _gameTransitionToDay() {
    _state = GameState.day;

    notifyListeners();
  }

  /// Attempt to proceed to the next role
  /// or transition into the day phase.
  /// If the current role hasn't exhausted all his mandatory abilities
  /// the game will not progress.
  void _next(BuildContext context) {
    if (_state == GameState.night) {
      if (_checkAllUnskippableAbilitiesUse()) {
        _setNextIndex(context);
      } else {
        showStandardAlert('Unable to proceed',
            'At least one mandatory ability was not used during this turn.', context);
      }
    }
  }

  /// Check if the ability is available at the current night.
  bool _isAbilityAvailableAtNight(Ability ability) {
    return ability.isForNight() &&
        ability.useCount != AbilityUseCount.none &&
        !ability.wasUsedInCurrentTurn(_currentTurn) &&
        ability.shouldBeAvailable();
  }

  /// Use the ability against the given targets
  /// and apply its post effect if it exists.
  List<Player> _useAbility(Ability ability, List<Player> targets) {
    List<Player> affected = ability.use(targets, _currentTurn);

    ability.usePostEffect(this, affected);

    notifyListeners();

    return affected;
  }

  /// Add a new member to the first group with the given `roleId`.
  /// We assume that the given roleId correspond to a `RoleGroup`
  /// and there is only one instance of that role in the list.
  void _addMemberToGroup(Player newMember, RoleId roleId) {
    for (var role in _roles) {
      if (role.id == roleId && role.isGroup()) {
        (role as RoleGroup).setPlayer([...role.player, newMember]);
        return;
      }
    }
  }

  /// Replace the current captain with the provided one,
  /// and kill the old one.
  /// We assume that there is only one captain instance.
  void _replaceCaptainPlayer(Player player) {
    for (var role in _roles) {
      if (role.id == RoleId.captain) {
        role as RoleSingular;

        /// Add the old captain to the graveyard due
        /// because he is the last to play.
        _killAndMovePlayerToGraveyard(role.getPlayer());

        /// Replace with the new captain.
        role.setPlayer(player);
        return;
      }
    }
  }

  /// Resolve specific roles interactions
  /// after a day ability has been executed.
  ///
  /// If a lover is dead, make sure that the other lover is dead too.
  void _resolveRolesInteractionsAfterAbilityUsedInDay() {
    if (_state != GameState.day) return;

    getPlayersList().forEach((player) {
      /// If the captain is dead.
      if (player.hasFatalEffect() && player.hasEffect(StatusEffectType.isServed)) {
        Role theOldRole = getRole(player.getMainRole().id)!;

        onServedDeath(theOldRole, () {
          /// If the main role is captain,
          /// we send the bastard to the graveyard.
          /// Otherwise, we will be unable to use
          /// the captain's abilities which
          /// should not happen.
          if (player.getMainRole().id == RoleId.captain) {
            _killAndMovePlayerToGraveyard(theOldRole.player);
          }

          /// We should search for pending abilities manually.
          /// We ignore the captain.
          _collectPendingAbilityOfPlayer(player, ignored: [RoleId.captain]);

          player.removeRoleOfType(theOldRole.id);
        });
      }
    });
  }

  void _collectPendingAbilityOfPlayer(Player player, {List<RoleId> ignored = const []}) {
    for (var role in player.roles) {
      if (ignored.contains(role.id)) continue;

      for (var ability in role.abilities) {
        if (ability.isUsable() &&
            ability.shouldBeUsedOnOwnerDeath() &&
            !_pendingAbilities.contains(ability)) {
          _pendingAbilities.add(ability);
        }
      }
    }
  }

  /// Collect pending abilities
  void _collectPendingAbilityInDay() {
    if (_state != GameState.day) return;

    getPlayersList().forEach((player) {
      if (player.hasFatalEffect()) {
        _collectPendingAbilityOfPlayer(player);
      }
    });
  }

  void _gameOverCheck(BuildContext context) {
    dynamic result = checkTeamsAreBalanced(getPlayersList(), _roles);

    if (result is Teams) {
      gameOver = true;
      showGameOverAlert(result, this, context);
    }
  }

  void _removeObsoleteRoles() {
    var toRemove = <Role>[];

    for (var role in _roles) {
      if (role.isObsolete()) {
        toRemove.add(role);
      }
    }

    for (var role in toRemove) {
      _roles.remove(role);
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/roles/servant.dart';
import 'package:werewolves/widgets/alert/game_over_alert.dart';
import 'package:werewolves/widgets/alert/game_step_alert.dart';
import 'package:werewolves/widgets/game/game_day_view.dart';
import 'package:werewolves/widgets/game/game_init_view.dart';
import 'package:werewolves/widgets/game/game_night_view.dart';
import 'package:werewolves/widgets/game/game_standard_alert.dart';
import 'package:werewolves/widgets/game/ability/use_ability.dart';
import 'package:werewolves/widgets/game/game_use_ability_done.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/alien.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/garrulous_wolf.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';

enum GameState {
  empty,
  initialized,
  night,
  day,
}

enum DayState { information, discussion, vote, execution, resolution }

class GameArguments {
  final List<Role> list;

  GameArguments(this.list);
}

class GameInformation {
  late final String _text;
  late final GameState _period;
  late final int _turn;

  String getText() {
    return _text;
  }

  GameState getPeriod() {
    return _period;
  }

  int getTurn() {
    return _turn;
  }

  GameInformation(this._text, this._turn, this._period);

  static GameInformation deathInformation(
      Player player, GameState period, int turn) {
    return GameInformation('${player.getName()} died.', turn, period);
  }

  static GameInformation talkInformation(
      Player player, GameState period, int turn) {
    return GameInformation(
        '${player.getName()} starts the discussion.', turn, period);
  }

  static GameInformation clairvoyanceInformation(
      RoleId role, GameState period, int turn) {
    return GameInformation('The seer saw : ${getRoleName(role)}', turn, period);
  }

  static GameInformation servantInformation(
      RoleId role, GameState period, int turn) {
    return GameInformation(
        'The servant became ${getRoleName(role)}.', turn, period);
  }

  static GameInformation judgeInformation(Player player, int turn) {
    return GameInformation(
        'The Judge portected ${player.getName()}.', turn, GameState.night);
  }

  static GameInformation mutedInformation(Player player, int turn) {
    return GameInformation(
        '${player.getName()} is muted.', turn, GameState.night);
  }

  static GameInformation sheepInformation(bool killed, int turn) {
    return GameInformation(
        killed ? 'A sheep was killed' : 'A sheep returned to the shepherd.',
        turn,
        GameState.night);
  }
}

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
  void useAbilitInNight(
      Ability ability, List<Player> targets, BuildContext context) {
    if (!ability.isForNight()) return;

    var affected = useAbility(ability, targets);

    Navigator.pop(context);

    showAbilityAppliedMessage(
        context, getAbilityAppliedMessage(ability, affected));
  }

  /// Specific use case for [useAbility] during the day
  void useAbilityInDay(
      Ability ability, List<Player> targets, BuildContext context) {
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
            useAbilityInDay(
                currentPendingAbility, currentAbilityTargets, context);
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
  List<Player> getPlayersWithStatusEffects(List<EffectId> effects) {
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
        .where((item) =>
            item.getTurn() == _currentTurn &&
            item.getPeriod() == GameState.night)
        .toList();
  }

  /// Return the list of the current day informations.
  List<GameInformation> getCurrentDaySummary() {
    return _infos
        .where((item) =>
            item.getTurn() == _currentTurn && item.getPeriod() == GameState.day)
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

    if (maybeNewTeam is Team &&
        maybeNewTeam != (servant.player as Player).team) {
      (servant.player as Player).team = maybeNewTeam;
    }

    _roles.add(newRole);

    /// Remove the [serving] effect from the servant player;
    /// No need to remove the [served] effects
    /// because the dead player will be sent to the graveyard.
    (servant.player as Player).removeEffectsOfType(EffectId.isServing);

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
    addGameInfo(GameInformation.servantInformation(
        deadRole.id, getState(), getCurrentTurn()));

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

    var probablyNextIndex =
        _roles.indexWhere((element) => element.callingPriority == next);

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

    _currentIndex =
        _roles.indexWhere((element) => element.callingPriority == min);
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
        showStandardAlert(
            'Unable to proceed',
            'At least one mandatory ability was not used during this turn.',
            context);
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
      if (player.hasFatalEffect() && player.hasEffect(EffectId.isServed)) {
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

  void _collectPendingAbilityOfPlayer(Player player,
      {List<RoleId> ignored = const []}) {
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

    if (result is Team) {
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

void resolveEffectsAndCollectInfosOfNight(GameModel game) {
  int currentTurn = game.getCurrentTurn();

  game.getPlayersList().forEach((player) {
    final newEffects = <Effect>[];

    for (var effect in player.effects) {
      /// do not remove permanent or fatal effects.
      /// Fatal effects will be treated later
      /// by confirming the death of the players
      /// and moving them into the graveyard.
      if (effect.permanent || isFatalEffect(effect.type)) {
        continue;
      }

      switch (effect.type) {

        /// Protector -----------------------------------------------------
        case EffectId.isProtected:

          /// currently protected player could not be protected again
          /// add [wasProtected] effect
          /// so he won't be targeted by the protector in the next turn.
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasProtectedEffect(effect.source));
          break;

        /// Black Wolf ----------------------------------------------------
        case EffectId.isMuted:

          /// Currently muted player cannot be muted two night in a row
          /// so we add [wasMuted] effect.
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasMutedEffect(effect.source));

          if (!(effect.source.player as Player).hasFatalEffect()) {
            game.addGameInfo(
                GameInformation.mutedInformation(player, currentTurn));
          }

          break;

        /// Seer ----------------------------------------------------------
        case EffectId.isSeen:
          player.removeEffectsOfType(effect.type);

          /// If the seer is dead, we do not report anything
          if ((effect.source as RoleSingular).player.hasFatalEffect()) {
            break;
          }

          Role role = resolveSeenRole(player);

          game.addGameInfo(GameInformation.clairvoyanceInformation(
              role.id, game.getState(), currentTurn));

          break;

        /// Judge --------------------------------------------------------
        /// Role cannot be protected by the judge two consecutive rounds.
        case EffectId.isJudged:
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasJudgedEffect(effect.source));

          game.addGameInfo(
              GameInformation.judgeInformation(player, currentTurn));
          break;

        /// Captain ------------------------------------------------------
        case EffectId.shouldTalkFirst:
          game.addGameInfo(GameInformation.talkInformation(
              player, game.getState(), currentTurn));

          player.removeEffectsOfType(effect.type);
          break;

        /// Shepherd -----------------------------------------------------
        case EffectId.hasSheep:

          /// If the player has a wolf role
          /// We should remove one sheep
          /// which in our case is the target count.
          if (player.hasWolfRole()) {
            Ability shepherdAbility =
                effect.source.getAbilityOfType(AbilityId.sheeps)!;

            shepherdAbility.targetCount--;
            game.addGameInfo(
                GameInformation.sheepInformation(true, currentTurn));
          } else {
            game.addGameInfo(
                GameInformation.sheepInformation(false, currentTurn));
          }

          player.removeEffectsOfType(effect.type);
          break;

        /// Common effects -----------------------------------------------
        /// Should only be removed.
        case EffectId.isRevived:
        case EffectId.isSubstitue:
        case EffectId.hasInheritedCaptaincy:
        case EffectId.wasProtected:
        case EffectId.wasJudged:
        case EffectId.wasMuted:
        case EffectId.shouldSayTheWord:
          player.removeEffectsOfType(effect.type);
          break;

        /// Unreachable code because these effects are permanent. --------
        /// Fatal or permanent effects.
        case EffectId.isCountered:
        case EffectId.isExecuted:
        case EffectId.isDevoured:
        case EffectId.isHunted:
        case EffectId.isCursed:
        case EffectId.hasCallsign:
        case EffectId.isInfected:
        case EffectId.isServed:
        case EffectId.isServing:
        case EffectId.isGuessed:
          break;
      }
    }

    /// Apply new effects
    for (var effect in newEffects) {
      player.addStatusEffect(effect);
    }
  });
}

List<Role> makeAvailableList() {
  Player player() => Player("Placeholder_Player");

  List<Role> output = [];

  for (var element in RoleId.values) {
    switch (element) {
      case RoleId.protector:
        output.add(Protector(player()));
        break;
      case RoleId.werewolf:
        output.add(Werewolf(player()));
        break;
      case RoleId.fatherOfWolves:
        output.add(FatherOfWolves(player()));
        break;
      case RoleId.witch:
        output.add(Witch(player()));
        break;
      case RoleId.seer:
        output.add(Seer(player()));
        break;
      case RoleId.knight:
        output.add(Knight(player()));
        break;
      case RoleId.hunter:
        output.add(Hunter(player()));
        break;
      case RoleId.captain:
        output.add(Captain(player()));
        break;
      case RoleId.villager:
        output.add(Villager(player()));
        break;
      case RoleId.judge:
        output.add(Judge(player()));
        break;
      case RoleId.blackWolf:
        output.add(BlackWolf(player()));
        break;
      case RoleId.garrulousWolf:
        output.add(GarrulousWolf(player()));
        break;
      case RoleId.shepherd:
        output.add(Shepherd(player()));
        break;
      case RoleId.alien:
        output.add(Alien(player()));
        break;

      /// Not ready for production -------------------------------------------
      case RoleId.servant:
        break;

      /// Group roles --------------------------------------------------------
      /// Will be injected automatically later,
      /// when roles have been distributed.
      case RoleId.wolfpack:
        break;
    }
  }

  return output;
}

void resolveEffectsAndCollectInfosOfDay(GameModel game) {
  int currentTurn = game.getCurrentTurn();

  game.getPlayersList().forEach((player) {
    if (player.hasFatalEffect()) {
      game.addGameInfo(
          GameInformation.deathInformation(player, GameState.day, currentTurn));
    }
  });
}

int getWolfTeamCount(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (player.team == Team.wolves) {
      sum++;
    }
  }

  return sum;
}

int getVillageTeamCount(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (player.team == Team.village) {
      sum++;
    }
  }

  return sum;
}

int getSoloTeamsCount(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (![Team.village, Team.wolves].contains(player.team)) {
      sum++;
    }
  }

  return sum;
}

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

List<Player> extractPlayersList(List<Role> roles) {
  List<Player> output = [];

  for (var role in roles) {
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

dynamic checkListIsValid(List<Role> roles) {
  if (roles.length < 7) {
    return "Player count is too short to start a game. Try adding more roles to reach at least 7 players.";
  }

  dynamic balanced = checkTeamsAreBalanced(extractPlayersList(roles), roles);

  if (balanced != true) {
    return "Game is not balanced, ${getTeamName(balanced)} team is already winning.";
  }

  return true;
}

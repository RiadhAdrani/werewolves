import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/app/routing.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/use_ability_model.dart';
import 'package:werewolves/models/use_alien_ability_model.dart';
import 'package:werewolves/utils/dialogs.dart';
import 'package:werewolves/utils/toast.dart';
import 'package:werewolves/widgets/ability.dart';
import 'package:werewolves/widgets/game.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';

enum GameState {
  empty,
  initialized,
  night,
  day,
}

enum DayState {
  information,
  discussion,
  vote,
  execution,
  resolution,
}

enum EventId {
  death,
  talkFirst,
  transformed,
  sheepDied,
  sheepReturned,
  seen,
  judged,
  muted,
}

class GameArguments {
  final List<Role> list;

  GameArguments(this.list);
}

class Event {
  late final String text;
  late final GameState period;
  late final int turn;
  late final EventId effect;

  Event(this.text, this.turn, this.period, this.effect);

  static Event death(Player player, GameState period, int turn) {
    return Event(
      t(LK.eventDeath, params: {'name': player.name}),
      turn,
      period,
      EventId.death,
    );
  }

  static Event talk(Player player, GameState period, int turn) {
    return Event(
      t(LK.eventTalk, params: {'name': player.name}),
      turn,
      period,
      EventId.talkFirst,
    );
  }

  static Event clairvoyance(RoleId role, GameState period, int turn) {
    return Event(
      t(LK.eventClairvoyance, params: {'name': getRoleName(role)}),
      turn,
      period,
      EventId.seen,
    );
  }

  static Event servant(RoleId role, GameState period, int turn) {
    return Event(
      'The servant became ${getRoleName(role)}.',
      turn,
      period,
      EventId.transformed,
    );
  }

  static Event judge(Player player, int turn) {
    return Event(
      t(LK.eventJudge, params: {'name': player.name}),
      turn,
      GameState.night,
      EventId.judged,
    );
  }

  static Event mute(Player player, int turn) {
    return Event(
      t(LK.eventMute, params: {'name': player.name}),
      turn,
      GameState.night,
      EventId.muted,
    );
  }

  static Event sheep(bool killed, int turn) {
    return Event(
      t(killed ? LK.eventSheepDead : LK.eventSheepReturned),
      turn,
      GameState.night,
      killed ? EventId.sheepDied : EventId.sheepReturned,
    );
  }
}

class Game extends ChangeNotifier {
  final List<Role> roles = [];
  final List<Player> graveyard = [];
  final List<Event> events = [];
  final List<Ability> pendingAbilities = [];

  bool noContextMode = false;

  List<Role> called = [];
  List<Role> available = [];

  GameState state = GameState.empty;
  int currentIndex = -1;
  int currentTurn = 0;
  bool isOver = false;

  List<Role> get rolesForDebug {
    return roles;
  }

  List<Role> get playableRoles {
    return roles.where((role) => !role.isObsolete).toList();
  }

  bool get hasPendingAbilities {
    return pendingAbilities.isNotEmpty;
  }

  /// Return a list of alive players.
  /// Used for possible future role `Shaman`
  /// Add add them to the output list.
  List<Player> get playersList {
    List<Player> output = [];

    for (var role in roles) {
      if (!role.isGroup) {
        if (!output.contains(role.controller)) {
          if (!(role.controller as Player).isDead) {
            output.add(role.controller);
          }
        }
      }
    }

    return output;
  }

  List<Player> get deadPlayers {
    return graveyard;
  }

  /// Return currently active role.
  Role? get currentRole {
    if (state != GameState.night || currentIndex == -1) return null;

    return available[currentIndex];
  }

  /// Return the correct widget to be displayed
  /// during the current `state`.
  /// TODO (test)
  Widget useView(BuildContext context) {
    switch (state) {
      case GameState.empty:
        return Text(t(LK.loading));
      case GameState.initialized:
        return gamePreView(this, context);
      case GameState.night:
        return gameNightView(this, context);
      case GameState.day:
        return gameDayView(this, context);
    }
  }

  void init(List<Role> list) {
    roles.addAll(list);

    state = GameState.initialized;
    notifyListeners();
  }

  void start() {
    state = GameState.night;

    called = [];
    available = roles
        .where((role) => role.shouldBeCalledAtNight(roles, currentTurn))
        .toList();

    currentIndex = nextIndex(currentRole, roles, available, called,
        test: (role) => role.shouldBeCalledAtNight(roles, currentTurn));

    notifyListeners();
  }

  void next(BuildContext context) {
    if (state != GameState.night) {
      throw 'Unexpected game state : $state .';
    }

    if (currentRole == null) {
      throw 'currentRole is null.';
    }

    bool mandatory = currentRole!.abilities.every((ability) {
      bool $used = ability.wasUsedInTurn(currentTurn);
      bool $unskippable = ability.isUnskippable();
      bool $emptyTargets = ability
          .createListOfTargets(
            playersList,
            currentTurn,
          )
          .isNotEmpty;

      return !$used && $unskippable && $emptyTargets;
    });

    if (mandatory) {
      if (!noContextMode) {
        showToast(t(LK.gameNightMandatoryAbilityNotUsed));
      }

      return;
    }

    int index = nextIndex(
      currentRole,
      roles,
      available,
      called,
      test: (role) => role.shouldBeCalledAtNight(roles, currentTurn),
    );

    if (index == -1) {
      var again = roles
          .where((role) =>
              role.shouldBeCalledAgainBeforeNightEnd(roles, currentTurn))
          .toList();

      // var missed = calculateRolesWithMissingEffects();

      List<Role> pending = <Role>{...again}.toList();

      if (pending.isNotEmpty) {
        available = pending;
        called = [];

        currentIndex = -1;
        currentIndex = nextIndex(
          currentRole,
          roles,
          available,
          called,
          test: (role) => role.shouldBeCalledAtNight(roles, currentTurn),
        );
      } else {
        state = GameState.day;
      }

      notifyListeners();
    } else {
      Role $new = available[index];

      called.add(currentRole!);
      available.remove(currentRole);

      currentIndex = available.indexOf($new);
      notifyListeners();

      ValidationWithEffect valEffect =
          currentRole!.onBeforeCalled(context, this);

      if (!valEffect.valid) {
        valEffect.useEffect(context, this);
      }
    }
  }

  void nextNight() {
    if (state != GameState.day) {
      throw 'Unexpected game state : $state .';
    }

    currentIndex = -1;
    currentTurn += 1;

    start();
  }

  /// TODO (test)
  Role? getRole(RoleId id) {
    return getRoleInGame(id, roles);
  }

  /// TODO (test)
  List<Role> calculateRolesWithMissingEffects() {
    if (state != GameState.night) {
      throw 'Unexpected game state : $state .';
    }

    var players = usePlayerExtractor(roles);
    List<EffectId> existing = [];
    for (var element in players) {
      existing.addAll(element.effects.map((e) => e.id));
    }

    var mandatory = calculateMandatoryEffects(roles, currentTurn);

    List<Role> missing = mandatory
        .where((item) => !existing.contains(item.id))
        .map((e) => e.role)
        .toList();

    return missing;
  }

  /// TODO (test)
  void addPendingAbility(Ability ability) {
    pendingAbilities.add(ability);
  }

  /// Use to start a new turn.
  void startTurn() {
    gameTransitionToNight();
  }

  /// Specific use case for [useAbility] during the night
  void useAbilityInNight(
    Ability ability,
    List<Player> targets,
    BuildContext context,
  ) {
    if (!ability.isForNight) return;

    var affected = useAbility(ability, targets);

    Navigator.pop(context);

    showAlert(
      context,
      t(LK.gameAbilityUsed),
      getAbilityAppliedMessage(ability, affected),
    );
  }

  /// Specific use case for [useAbility] during the day
  void useAbilityInDay(
    Ability ability,
    List<Player> targets,
    BuildContext context,
  ) {
    if (!ability.isForDay) return;

    useAbility(ability, targets);

    // Navigator.pop(context);

    notifyListeners();

    resolveRolesInteractionsAfterAbilityUsedInDay();

    _collectPendingAbilityInDay();

    void useNext() {
      if (pendingAbilities.isNotEmpty) {
        Ability currentPendingAbility = pendingAbilities[0];

        pendingAbilities.removeAt(0);

        notifyListeners();

        if (currentPendingAbility
            .createListOfTargets(playersList, currentTurn)
            .isEmpty) {
          useNext();
          return;
        }

        showDialog(
            context: context,
            builder: (context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: stepAlert(
                  t(LK.gameDayAbilityTriggeredTitle),
                  t(LK.gameDayAbilityTriggeredText,
                      params: {'name': currentPendingAbility.owner.name}),
                  getCurrentDaySummary().map((item) => item.text).toList(),
                  context,
                  () {
                    showUseAbilityDialog(
                      context,
                      currentPendingAbility,
                      (
                        List<Player> currentAbilityTargets,
                      ) {
                        useAbilityInDay(
                          currentPendingAbility,
                          currentAbilityTargets,
                          context,
                        );
                      },
                      cancelable: false,
                    );
                  },
                ),
              );
            });
      } else {
        eliminateDeadPlayers();

        notifyListeners();

        gameOverCheck(context);
      }
    }

    useNext();
  }

  /// Return the appropriate message depending on the affected list.
  String getAbilityAppliedMessage(Ability ability, List<Player> affected) {
    return ability.onAppliedMessage(affected);
  }

  /// Add a game info
  void addGameEvent(Event info) {
    events.add(info);
  }

  /// Return a list of players with specific effects
  List<Player> getPlayersWithEffects(List<EffectId> effects) {
    final output = <Player>[];

    for (var player in playersList) {
      for (var effect in effects) {
        if (!player.hasEffect(effect)) {
          continue;
        }
      }

      output.add(player);
    }

    return output;
  }

  /// Return a list of players with fatal effects
  List<Player> getPlayersWithFatalEffects() {
    final output = <Player>[];

    for (var player in playersList) {
      if (player.hasFatalEffect) {
        output.add(player);
      }
    }

    return output;
  }

  /// Return the list of the last night informations.
  List<Event> getCurrentTurnSummary() {
    return events
        .where((item) =>
            item.turn == currentTurn && item.period == GameState.night)
        .toList();
  }

  /// Return the list of the current day informations.
  List<Event> getCurrentDaySummary() {
    return events
        .where(
            (item) => item.turn == currentTurn && item.period == GameState.day)
        .toList();
  }

  /// Return the abilities that could be used, by sign callers or others during the day phase.
  List<Ability> getDayAbilities() {
    final output = <Ability>[];

    /// Fetch role that can use abilities and has a callsign
    for (var role in roles) {
      if (role.isObsolete == false &&
          role.canUseSignWithNarrator() &&
          role.canUseAbilitiesDuringDay()) {
        for (var ability in role.abilities) {
          if (ability.isForDay && ability.isPlenty) {
            output.add(ability);
          }
        }
      }
    }

    /// Add captain execution ability
    for (var role in roles) {
      /// We check the captain is obsolete.
      /// kinda useless but
      /// There should only be one instance of captain
      /// within the list of roles.
      if (role.isObsolete == false && role.id == RoleId.captain) {
        for (var ability in role.abilities) {
          if (ability.id == AbilityId.execute) {
            output.add(ability);
          }
        }
      }
    }

    return output;
  }

  /// We assume that the player `hasFatalEffect()`.
  /// we set the status of survivability to false,
  /// add the player to the graveyard (r.i.p)
  /// add a game info
  void killAndMovePlayerToGraveyard(Player player) {
    player.isAlive = false;
    graveyard.add(player);
    addGameEvent(Event.death(player, state, currentTurn));
  }

  /// Perform mass murder on the souls of the already dead players.
  /// Should be used on the list of alive players.
  ///
  /// uses `GameModel._killAndMovePlayerToGraveyard()`.
  void eliminateDeadPlayers() {
    for (var player in playersList) {
      if (player.hasFatalEffect) {
        killAndMovePlayerToGraveyard(player);
      }
    }
  }

  /// Perform after night processes of
  /// resolving status effects
  /// and eliminating dead souls.
  /// When everything is done, we transition into the day phase.
  void performPostNightProcessing(BuildContext context) {
    List<Event> infos = resolveNightEffects(playersList, currentTurn);

    events.addAll(infos);

    eliminateDeadPlayers();

    gameOverCheck(context);

    gameTransitionToDay();
  }

  /// Find the index of the first role that should start the night.
  void initCurrentIndex() {
    if (roles.isEmpty) return;

    var min = 999999;

    for (var role in roles) {
      if (role.callingPriority < min &&
          role.callingPriority > -1 &&
          role.shouldBeCalledAtNight(roles, currentTurn) &&
          role.isObsolete == false) {
        min = role.callingPriority;
      }
    }

    currentIndex =
        roles.indexWhere((element) => element.callingPriority == min);
  }

  /// Start a new turn and transition into the night.
  /// Increment the current turn
  /// and initialize the current index.
  void gameTransitionToNight() {
    removeObsoleteRoles();

    currentTurn = currentTurn + 1;
    state = GameState.night;

    initCurrentIndex();

    notifyListeners();
  }

  /// Transition into the day phase.
  void gameTransitionToDay() {
    state = GameState.day;

    notifyListeners();
  }

  /// Check if the ability is available at the current night.
  bool isAbilityAvailableAtNight(Ability ability) {
    return ability.isForNight &&
        ability.useCount != AbilityUseCount.none &&
        !ability.wasUsedInTurn(currentTurn) &&
        ability.shouldBeAvailable();
  }

  /// Use the ability against the given targets
  /// and apply its post effect if it exists.
  List<Player> useAbility(Ability ability, List<Player> targets) {
    List<Player> affected = ability.use(targets, currentTurn);

    ability.usePostEffect(this, affected);

    notifyListeners();

    return affected;
  }

  /// Add a new member to the first group with the given `roleId`.
  /// We assume that the given roleId correspond to a `RoleGroup`
  /// and there is only one instance of that role in the list.
  void addMemberToGroup(Player newMember, RoleId roleId) {
    for (var role in roles) {
      if (role.id == roleId && role.isGroup) {
        (role as RoleGroup).setPlayer([...role.controller, newMember]);
        return;
      }
    }
  }

  /// Replace the current captain with the provided one,
  /// and kill the old one.
  /// We assume that there is only one captain instance.
  void replaceCaptainPlayer(Player player) {
    for (var role in roles) {
      if (role.id == RoleId.captain) {
        role as RoleSingular;

        /// Add the old captain to the graveyard due
        /// because he is the last to play.
        killAndMovePlayerToGraveyard(role.controller);

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
  void resolveRolesInteractionsAfterAbilityUsedInDay() {
    if (state != GameState.day) return;

    for (var player in playersList) {
      /// If the captain is dead.
      if (player.hasFatalEffect && player.hasEffect(EffectId.isServed)) {}
    }
  }

  void collectPendingAbilityOfPlayer(Player player,
      {List<RoleId> ignored = const []}) {
    for (var role in player.roles) {
      if (ignored.contains(role.id)) continue;

      for (var ability in role.abilities) {
        if (ability.isPlenty &&
            ability.shouldBeUsedOnDeath() &&
            !pendingAbilities.contains(ability)) {
          pendingAbilities.add(ability);
        }
      }
    }
  }

  /// Collect pending abilities
  void _collectPendingAbilityInDay() {
    if (state != GameState.day) return;

    for (var player in playersList) {
      if (player.hasFatalEffect) {
        collectPendingAbilityOfPlayer(player);
      }
    }
  }

  void gameOverCheck(BuildContext context) {
    dynamic result = useTeamsBalanceChecker(playersList, roles);

    if (result is Team) {
      isOver = true;
      showConfirm(context, 'Game Over', 'The ${getTeamName(result)} Team won !',
          () {
        dispose();
        Navigator.popUntil(context, ModalRoute.withName(Screen.home.path));
      });
    }
  }

  void removeObsoleteRoles() {
    var toRemove = <Role>[];

    for (var role in roles) {
      if (role.isObsolete) {
        toRemove.add(role);
      }
    }

    for (var role in toRemove) {
      roles.remove(role);
    }
  }

  void showUseAbilityDialog(BuildContext context, Ability ability,
      Function(List<Player>) onAbilityUsed,
      {bool cancelable = true}) {
    List<Player> targetList = ability.createListOfTargets(
      playersList,
      currentTurn,
    );

    switch (ability.ui) {
      case AbilityUI.normal:
        {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ChangeNotifierProvider(
                  create: (context) => UseAbilityModel(ability),
                  builder: (context, child) {
                    final model = context.watch<UseAbilityModel>();

                    return abilityDialog(
                        model, context, ability, targetList, onAbilityUsed);
                  },
                );
              });
          break;
        }
      case AbilityUI.alien:
        {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return ChangeNotifierProvider(
                  create: (context) => UseAlienAbilityModel(
                    targetList,
                    playableRoles,
                  ),
                  builder: (context, child) {
                    final model = context.watch<UseAlienAbilityModel>();

                    return alienAbilityDialog(
                      context,
                      model,
                      ability,
                      targetList,
                      onAbilityUsed,
                      playableRoles,
                    );
                  },
                );
              });
          break;
        }
    }
  }
}

List<Player> getPlayersWithEffects(
    List<Player> players, List<EffectId> effects) {
  final output = <Player>[];

  for (var player in players) {
    for (var effect in effects) {
      if (!player.hasEffect(effect)) {
        continue;
      }
    }

    output.add(player);
  }

  return output;
}

List<Player> getPlayersWithFatalEffect(List<Player> players) {
  final output = <Player>[];

  for (var player in players) {
    if (player.hasFatalEffect) {
      output.add(player);
    }
  }

  return output;
}

List<Event> resolveNightEffects(
  List<Player> players,
  int currentTurn,
) {
  List<Event> infos = [];

  for (var player in players) {
    final newEffects = <Effect>[];

    for (var effect in player.effects) {
      /// do not remove permanent or fatal effects.
      /// Fatal effects will be treated later
      /// by confirming the death of the players
      /// and moving them into the graveyard.
      if (effect.isPermanent || isFatalEffect(effect.id)) {
        continue;
      }

      switch (effect.id) {

        /// Protector -----------------------------------------------------
        case EffectId.isProtected:

          /// currently protected player could not be protected again
          /// add [wasProtected] effect
          /// so he won't be targeted by the protector in the next turn.
          player.removeEffectsOfType(effect.id);
          newEffects.add(WasProtectedEffect(effect.source));
          break;

        /// Black Wolf ----------------------------------------------------
        case EffectId.isMuted:

          /// Currently muted player cannot be muted two night in a row
          /// so we add [wasMuted] effect.
          player.removeEffectsOfType(effect.id);
          newEffects.add(WasMutedEffect(effect.source));

          if (!(effect.source.controller as Player).hasFatalEffect) {
            infos.add(Event.mute(player, currentTurn));
          }

          break;

        /// Seer ----------------------------------------------------------
        case EffectId.isSeen:
          player.removeEffectsOfType(effect.id);

          /// If the seer is dead, we do not report anything
          if ((effect.source as RoleSingular).controller.hasFatalEffect) {
            break;
          }

          Role role = resolveSeenRole(player);

          infos.add(Event.clairvoyance(role.id, GameState.night, currentTurn));

          break;

        /// Judge --------------------------------------------------------
        /// Role cannot be protected by the judge two consecutive rounds.
        case EffectId.isJudged:
          player.removeEffectsOfType(effect.id);
          newEffects.add(WasJudgedEffect(effect.source));

          infos.add(Event.judge(player, currentTurn));
          break;

        /// Captain ------------------------------------------------------
        case EffectId.shouldTalkFirst:
          infos.add(Event.talk(player, GameState.night, currentTurn));

          player.removeEffectsOfType(effect.id);
          break;

        /// Shepherd -----------------------------------------------------
        case EffectId.hasSheep:

          /// If the player has a wolf role
          /// We should remove one sheep
          /// which in our case is the target count.
          if (player.hasWolfRole) {
            Ability shepherdAbility =
                effect.source.getAbilityOfType(AbilityId.sheeps)!;

            shepherdAbility.targetCount--;

            infos.add(Event.sheep(true, currentTurn));
          } else {
            infos.add(Event.sheep(false, currentTurn));
          }

          player.removeEffectsOfType(effect.id);
          break;

        /// Common effects -----------------------------------------------
        /// Should only be removed.
        case EffectId.isRevived:
        case EffectId.isSubstitue:
        case EffectId.hasInheritedCaptaincy:
        case EffectId.wasProtected:
        case EffectId.wasJudged:
        case EffectId.wasMuted:
        case EffectId.hasWord:
          player.removeEffectsOfType(effect.id);
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
        case EffectId.isGuessedByAlien:
          break;
      }
    }

    /// Apply new effects
    for (var effect in newEffects) {
      player.addEffect(effect);
    }
  }

  // TODO : process dead players

  // TODO : process remove obsolete roles

  return infos;
}

/// generate a list of playable roles.
List<Role> usePlayableRolesGenerator() {
  List<RoleId> playable =
      RoleId.values.where((id) => useRole(id).pickable).toList();

  return playable
      .map((id) => useRole(id).create([Player('Placeholder')]))
      .toList();
}

void useDayEffectsResolver(Game game) {
  int currentTurn = game.currentTurn;

  for (var player in game.playersList) {
    if (player.hasFatalEffect) {
      game.addGameEvent(Event.death(player, GameState.day, currentTurn));
    }
  }
}

/// returns the number of players within the wolf team.
int calculateWolves(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (player.team == Team.wolves) {
      sum++;
    }
  }

  return sum;
}

/// returns the number of players within the village team.
int calculateVillagers(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (player.team == Team.village) {
      sum++;
    }
  }

  return sum;
}

/// returns the number of solo players.
int calculateSolos(List<Player> players) {
  int sum = 0;

  for (var player in players) {
    if (![Team.village, Team.wolves].contains(player.team)) {
      sum++;
    }
  }

  return sum;
}

/// check if the current list of players is balanced,
/// otherwise, it returns the winning team.
dynamic useTeamsBalanceChecker(List<Player> players, List<Role> roles) {
  int wolvesCount = calculateWolves(players);
  int villagersCount = calculateVillagers(players);
  int solosCount = calculateSolos(players);

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
        protector != null && protector.controller.team == Team.village;

    bool witchCanWinIt = (witch != null &&
        witch.controller.team == Team.village &&
        (witch.hasUnusedAbilityOfType(AbilityId.curse) ||
            witch.hasUnusedAbilityOfType(AbilityId.revive)));

    bool knightCanWinIt = (knight != null &&
        knight.controller.team == Team.village &&
        knight.hasUnusedAbilityOfType(AbilityId.counter));

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

/// check if the given role is still active in the given list.
Role? getRoleInGame(RoleId id, List<Role> roles) {
  for (var role in roles) {
    if (role.id == id && !role.isObsolete) {
      return role;
    }
  }

  return null;
}

/// extract the list of players from the given list of roles
List<Player> usePlayerExtractor(List<Role> roles) {
  List<Player> output = [];

  for (var role in roles) {
    if (!role.isGroup) {
      role.controller as Player;
      if (!output.contains(role.controller)) {
        if (!(role.controller as Player).isDead) {
          output.add(role.controller);
        }
      }
    }
  }

  return output;
}

int nextIndex(
  Role? current,
  List<Role> roles,
  List<Role> available,
  List<Role> called, {
  bool Function(Role)? test,
}) {
  if (available.isEmpty) return -1;

  int next = 9999999;
  int index = -1;

  for (var i = 0; i < available.length; i++) {
    Role role = available[i];

    bool $diff = current != role;
    bool $test = test?.call(role) ?? true;
    bool $priority =
        (current == null || (role.callingPriority >= current.callingPriority));
    bool $callable = role.callable;
    bool $nextPriority = role.callingPriority < next;
    bool $obsolete = !role.isObsolete;

    if ($diff &&
        $priority &&
        $callable &&
        $nextPriority &&
        $obsolete &&
        $test) {
      next = role.callingPriority;
      index = i;
    }
  }

  return index;
}

class MandatoryEffect {
  EffectId id;
  Role role;

  MandatoryEffect(this.id, this.role);
}

List<MandatoryEffect> calculateMandatoryEffects(List<Role> roles, int turn) {
  List<MandatoryEffect> list = [];

  for (var role in roles) {
    switch (role.id) {
      case RoleId.werewolf:
      case RoleId.fatherOfWolves:
      case RoleId.witch:
      case RoleId.alien:
      case RoleId.villager:
      case RoleId.wolfpack:
      case RoleId.servant:
      case RoleId.knight:
      case RoleId.shepherd:
      case RoleId.hunter:
        {
          break;
        }
      case RoleId.protector:
        {
          list.add(MandatoryEffect(EffectId.isProtected, role));
          break;
        }
      case RoleId.seer:
        {
          list.add(MandatoryEffect(EffectId.isSeen, role));
          break;
        }
      case RoleId.captain:
        {
          list.add(MandatoryEffect(EffectId.shouldTalkFirst, role));
          break;
        }
      case RoleId.judge:
        {
          list.add(MandatoryEffect(EffectId.isJudged, role));
          break;
        }
      case RoleId.blackWolf:
        {
          list.add(MandatoryEffect(EffectId.isMuted, role));
          break;
        }
      case RoleId.garrulousWolf:
        {
          list.add(MandatoryEffect(EffectId.hasWord, role));
          break;
        }
    }
  }

  return list;
}

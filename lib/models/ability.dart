import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

enum AbilityId {
  protect,
  devour,
  infect,
  clairvoyance,
  revive,
  curse,
  counter,
  hunt,
  callsign,
  serve,
  judgement,
  mute,
  word,
  sheeps,
  guess,

  // captain
  talker,
  execute,
  substitute,
  inherit
}

enum AbilityTime { night, day, both }

enum AbilityType { active, passive, both }

enum AbilityUI { normal, alien }

enum AbilityUseCount { once, infinite, none }

abstract class Ability {
  List<int> turnsUsedIn = [];

  late int targetCount;

  late Role owner;
  late AbilityId name;
  late AbilityType type;
  late AbilityUseCount useCount;
  late AbilityTime time;

  AbilityUI ui = AbilityUI.normal;

  /// Execute the ability on targets.
  List<Player> use(List<Player> targets, int turn) {
    List<Player> appliedTo = [];

    if (isUsable() && targets.isNotEmpty) {
      var subList =
          targetCount == 99 ? targets : targets.sublist(0, targetCount);

      for (var target in subList) {
        turnsUsedIn.add(turn);

        if (shouldBeAppliedSurely(target)) {
          appliedTo.add(target);

          callOnTarget(target);

          if (useCount == AbilityUseCount.once) {
            useCount = AbilityUseCount.none;
          }
        }
      }
    }

    return appliedTo;
  }

  String getName() {
    return getAbilityName(name);
  }

  bool isUsable() {
    return useCount != AbilityUseCount.none;
  }

  /// Check if the ability is used during the night
  bool isForNight() {
    return [AbilityTime.both, AbilityTime.night].contains(time);
  }

  /// Check if the ability is used during the day
  bool isForDay() {
    return [AbilityTime.both, AbilityTime.day].contains(time);
  }

  bool wasUsedInCurrentTurn(int turn) {
    return turnsUsedIn.contains(turn);
  }

  List<Player> createListOfTargetPlayers(Game game) {
    return game.playersList.where((player) => isTarget(player)).toList();
  }

  /// Check if the given target is valid or not.
  bool isTarget(Player target);

  /// Used as a last check
  /// that will confirm the application of the status effect
  /// on the target player.
  ///
  /// Example:
  ///
  /// Used with the devour ability to prevent
  /// the addition of the `devour` effect on a
  /// `protected` target.
  bool shouldBeAppliedSurely(Player target);

  /// Check if the ability could be used in the general scope.
  bool shouldBeAvailable();

  /// Check if the ability should be used during the night phase and cannot be skipped.
  bool isUnskippable();

  /// Called internally by `use()` method
  /// to execute the ability on each target.
  void callOnTarget(Player target);

  /// Return the appropriate message according to the number of affected players (target).
  String onAppliedMessage(List<Player> targets);

  /// Effect launched after the ability has applied successfully;
  void usePostEffect(Game game, List<Player> affected);

  /// Generate ability detailed description;
  String getDescription() {
    return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce consectetur pulvinar enim vitae blandit. Etiam lobortis velit a risus interdum, in fermentum dui venenatis. Nunc feugiat sapien at condimentum aliquam. Donec vitae odio pharetra, malesuada mi at, aliquam ante.';
  }

  /// Check if this ability should be used when the owner is dead.
  bool shouldBeUsedOnOwnerDeath();
}

String getAbilityName(AbilityId id) {
  switch (id) {
    case AbilityId.protect:
      return "Protect";
    case AbilityId.devour:
      return "Devour";
    case AbilityId.infect:
      return "Infect";
    case AbilityId.clairvoyance:
      return "Clairvoyance";
    case AbilityId.revive:
      return "Revive";
    case AbilityId.curse:
      return "Curse";
    case AbilityId.counter:
      return "Counter";
    case AbilityId.hunt:
      return "Hunt";
    case AbilityId.talker:
      return "Order";
    case AbilityId.execute:
      return "Execute";
    case AbilityId.substitute:
      return "Substitue";
    case AbilityId.inherit:
      return "Inherit";
    case AbilityId.callsign:
      return "Call sign";
    case AbilityId.serve:
      return "Serve";
    case AbilityId.judgement:
      return "Judge";
    case AbilityId.mute:
      return "Mute";
    case AbilityId.word:
      return "Garrulous Word";
    case AbilityId.sheeps:
      return "Sheeps";
    case AbilityId.guess:
      return "Guess";
  }
}

import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
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
import 'package:werewolves/objects/roles/witch.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

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
  late AbilityId id;
  late AbilityType type;
  late AbilityUseCount useCount;
  late AbilityTime time;

  AbilityUI ui = AbilityUI.normal;

  /// Execute the ability on targets.
  List<Player> use(List<Player> targets, int turn) {
    List<Player> appliedTo = [];

    if (isUsable && targets.isNotEmpty) {
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

  String get name {
    return getAbilityName(id);
  }

  bool get isUsable {
    return useCount != AbilityUseCount.none;
  }

  /// Check if the ability is used during the night
  bool get isForNight {
    return [AbilityTime.both, AbilityTime.night].contains(time);
  }

  /// Check if the ability is used during the day
  bool get isForDay {
    return [AbilityTime.both, AbilityTime.day].contains(time);
  }

  String get description {
    return getAbilityDescription(id);
  }

  bool wasUsedInTurn(int turn) {
    return turnsUsedIn.contains(turn);
  }

  List<Player> createListOfTargets(Game game) {
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

  /// Check if this ability should be used when the owner is dead.
  bool shouldBeUsedOnOwnerDeath();
}

Ability createAbilityFromId(AbilityId id, Role owner) {
  switch (id) {
    case AbilityId.protect:
      return ProtectAbility(owner);
    case AbilityId.devour:
      return DevourAbility(owner);
    case AbilityId.infect:
      return InfectAbility(owner);
    case AbilityId.clairvoyance:
      return ClairvoyanceAbility(owner);
    case AbilityId.revive:
      return ReviveAbility(owner);
    case AbilityId.curse:
      return CurseAbility(owner);
    case AbilityId.counter:
      return CounterAbility(owner);
    case AbilityId.hunt:
      return HuntAbility(owner);
    case AbilityId.callsign:
      return CallSignAbility(owner);
    case AbilityId.serve:
      return ServantAbility(owner);
    case AbilityId.judgement:
      return JudgementAbility(owner);
    case AbilityId.mute:
      return MuteAbility(owner);
    case AbilityId.word:
      return GarrulousAbility(owner);
    case AbilityId.sheeps:
      return ShepherdAbility(owner);
    case AbilityId.guess:
      return GuessAbility(owner);
    case AbilityId.talker:
      return TalkerAbility(owner);
    case AbilityId.execute:
      return ExecuteAbility(owner);
    case AbilityId.substitute:
      return SubstitueAbility(owner);
    case AbilityId.inherit:
      return InheritAbility(owner);
  }
}

String getAbilityDescription(AbilityId id) {
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

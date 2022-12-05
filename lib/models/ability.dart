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
import 'package:werewolves/utils/errors.dart';

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

const int infinite = 999;

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

    if (isPlenty && targets.isNotEmpty) {
      if (targets.length > targetCount) {
        throwException(
            'The number of targets is superior to the maximum allowed.');
      }

      for (var target in targets) {
        turnsUsedIn.add(turn);

        if (shouldBeAppliedSurely(target)) {
          callOnTarget(target);

          appliedTo.add(target);

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

  bool get isPlenty {
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

  List<Player> createListOfTargets(List<Player> players) {
    return players.where((player) => isTarget(player)).toList();
  }

  /// Return the appropriate message according to the number of affected players (target).
  String onAppliedMessage(List<Player> targets) {
    return useAbilityHelper(id).appliedMessage(targets);
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

  /// Effect launched after the ability has applied successfully;
  void usePostEffect(Game game, List<Player> affected);

  /// Check if this ability should be used when the owner is dead.
  bool shouldBeUsedOnDeath();
}

class AbilityHelperObject {
  late String name;
  late String description;
  late Ability Function(Role) create;
  late Function(List<Player> targets) appliedMessage;

  AbilityHelperObject(
      this.name, this.description, this.create, this.appliedMessage);
}

AbilityHelperObject useAbilityHelper(AbilityId id) {
  switch (id) {
    case AbilityId.protect:
      return AbilityHelperObject(
        'Protect',
        'Protect',
        (owner) => ProtectAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.devour:
      return AbilityHelperObject(
        'Devour',
        'Devour',
        (owner) => DevourAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.infect:
      return AbilityHelperObject(
        'Infect',
        'Infect',
        (owner) => InfectAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.clairvoyance:
      return AbilityHelperObject(
        'Clairvoyance',
        'Clairvoyance',
        (owner) => ClairvoyanceAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.revive:
      return AbilityHelperObject(
        'Revive',
        'Revive',
        (owner) => ReviveAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.curse:
      return AbilityHelperObject(
        'Curse',
        'Curse',
        (owner) => CurseAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.counter:
      return AbilityHelperObject(
        'Counter',
        'Counter',
        (owner) => CounterAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.hunt:
      return AbilityHelperObject(
        'Hunt',
        'Hunt',
        (owner) => HuntAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.callsign:
      return AbilityHelperObject(
        'CallSign',
        'CallSign',
        (owner) => CallSignAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.serve:
      return AbilityHelperObject(
        'Serve',
        'Serve',
        (owner) => ServantAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.judgement:
      return AbilityHelperObject(
        'Judgement',
        'Judgement',
        (owner) => JudgementAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.mute:
      return AbilityHelperObject(
        'Mute',
        'Mute',
        (owner) => MuteAbility(owner),
        (targets) => 'Ability Applied',
      );
    case AbilityId.word:
      return AbilityHelperObject(
        'Garrulous Word',
        'Garrulous Word',
        (owner) => GarrulousAbility(owner),
        (targets) => 'Effect Applied',
      );
    case AbilityId.sheeps:
      return AbilityHelperObject(
        'Shepherd',
        'Shepherd',
        (owner) => ShepherdAbility(owner),
        (targets) => 'Effect Applied',
      );
    case AbilityId.guess:
      return AbilityHelperObject(
        'Guess',
        'Guess',
        (owner) => GuessAbility(owner),
        (targets) => 'Effect Applied',
      );
    case AbilityId.talker:
      return AbilityHelperObject(
        'Talker',
        'Talker',
        (owner) => TalkerAbility(owner),
        (targets) => 'Effect Applied',
      );
    case AbilityId.execute:
      return AbilityHelperObject(
        'Execute',
        'Execute',
        (owner) => ExecuteAbility(owner),
        (targets) => 'Effect Applied',
      );
    case AbilityId.substitute:
      return AbilityHelperObject(
        'Substitute',
        'Substitute',
        (owner) => SubstitueAbility(owner),
        (targets) => 'Effect Applied',
      );
    case AbilityId.inherit:
      return AbilityHelperObject(
        'Inherit',
        'Inherit',
        (owner) => InheritAbility(owner),
        (targets) => 'Effect Applied',
      );
  }
}

Ability createAbilityFromId(AbilityId id, Role owner) {
  return useAbilityHelper(id).create(owner);
}

String getAbilityDescription(AbilityId id) {
  return useAbilityHelper(id).description;
}

String getAbilityName(AbilityId id) {
  return useAbilityHelper(id).name;
}

import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/transformers/strings/get_ability_name.dart';

abstract class Ability {
  List<int> turnsUsedIn = [];

  late int targetCount;

  late Role owner;
  late AbilityId name;
  late AbilityType type;
  late AbilityUseCount useCount;
  late AbilityTime time;

  /// Execute the ability on targets.
  List<Player> use(List<Player> targets, int turn) {
    List<Player> appliedTo = [];

    if (isUsable() && targets.isNotEmpty) {
      targets.sublist(0, targetCount).forEach((target) {
        turnsUsedIn.add(turn);

        if (shouldBeAppliedSurely(target)) {
          appliedTo.add(target);

          callOnTarget(target);

          if (useCount == AbilityUseCount.once) {
            useCount = AbilityUseCount.none;
          }
        }
      });
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

  List<Player> createListOfTargetPlayers(GameModel game) {
    return game.getPlayersList().where((player) => isTarget(player)).toList();
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
  void usePostEffect(GameModel game, List<Player> affected);

  /// Generate ability detailed description;
  String getDescription();

  /// Check if this ability should be used when the owner is dead.
  bool shouldBeUsedOnOwnerDeath();
}

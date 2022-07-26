import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/transformers/strings/get_ability_name.dart';

abstract class Ability {
  int targetCount = 0;

  late Role owner;
  late AbilityId name;
  late AbilityType type;
  late AbilityUseCount useCount;
  late AbilityTime time;

  /// Execute the ability on targets.
  void use(List<Player> targets) {
    if (isUsable()) {
      targets.sublist(0, targetCount).forEach((target) {
        if (shouldBeAppliedSurely(target)) {
          callOnTarget(target);

          if (useCount == AbilityUseCount.once) {
            useCount = AbilityUseCount.none;
          }
        }
      });
    }
  }

  String getName() {
    return getAbilityName(name);
  }

  bool isUsable() {
    return useCount != AbilityUseCount.none;
  }

  /// Check if the ability is used during the night
  bool isNightAbility() {
    return [AbilityTime.both, AbilityTime.night].contains(time);
  }

  /// Check if the ability is used during the day
  bool isDayAbility() {
    return [AbilityTime.both, AbilityTime.day].contains(time);
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
  bool shouldAbilityBeAvailable();

  /// Called internally by `use()` method
  /// to execute the ability on each target.
  void callOnTarget(Player target);
}

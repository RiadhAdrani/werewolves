import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/revive_effect.dart';

class ReviveAbility extends Ability {
  ReviveAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.revive;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(ReviveStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target.hasFatalEffect();
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldAbilityBeAvailable() {
    return true;
  }
}

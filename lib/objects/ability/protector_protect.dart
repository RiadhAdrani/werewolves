import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/protected_effect.dart';

class ProtectAbility extends Ability {
  ProtectAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.protect;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(ProtectStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return !target.hasEffect(StatusEffectType.wasProtected);
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

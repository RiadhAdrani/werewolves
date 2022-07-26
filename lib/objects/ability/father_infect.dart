import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/father_infect_effect.dart';

class InfectAbility extends Ability {
  InfectAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.infect;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(InfectStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target.hasEffect(StatusEffectType.isDevoured);
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return !target.hasEffect(StatusEffectType.isProtected);
  }

  @override
  bool shouldAbilityBeAvailable() {
    return true;
  }
}

import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/hunt_effect.dart';

class HuntAbility extends Ability {
  HuntAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.hunt;
    super.type = AbilityType.both;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.both;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(HuntStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target != owner.player;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldAbilityBeAvailable() {
    return (owner.player as Player).hasFatalEffect();
  }
}

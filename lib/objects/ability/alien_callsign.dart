import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';

class AlienCallSignAbility extends Ability {
  AlienCallSignAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.callsign;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(CallsignStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target == owner.player;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.player as Player).hasEffect(StatusEffectType.hasCallsign) &&
        !(owner.player as Player).hasFatalEffect();
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'Alien did not give his signal';

    return '${targets[0].name} has given his call sign.';
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return !(owner.player as Player).hasEffect(StatusEffectType.hasCallsign) &&
        !(owner.player as Player).hasFatalEffect();
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

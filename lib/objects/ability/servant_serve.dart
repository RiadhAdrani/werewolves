import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/serve_effect.dart';
import 'package:werewolves/objects/effects/serving_effect.dart';

class ServantAbility extends Ability {
  ServantAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.serve;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    (owner.player as Player).addStatusEffect(ServingStatusEffect(owner));
    target.addStatusEffect(ServeStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target != owner.player;
  }

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    return 'The servant is bound successfully.';
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.player as Player).hasEffect(StatusEffectType.isServing);
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {}
}

import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/devoured_effect.dart';

class DevourAbility extends Ability {
  DevourAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.devour;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(DevourStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return true;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return !target.hasEffect(StatusEffectType.isProtected);
  }

  @override
  bool shouldBeAvailable() {
    return true;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body has been devoured';

    return '${targets[0].name} has been devoured.';
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  String getDescription() {
    return 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce consectetur pulvinar enim vitae blandit. Etiam lobortis velit a risus interdum, in fermentum dui venenatis. Nunc feugiat sapien at condimentum aliquam. Donec vitae odio pharetra, malesuada mi at, aliquam ante.';
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

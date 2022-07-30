import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
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
    target.removeFatalEffects([]);
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
  bool shouldBeAvailable() {
    return true;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was revived.';

    return '${targets[0].name} has been revived.';
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

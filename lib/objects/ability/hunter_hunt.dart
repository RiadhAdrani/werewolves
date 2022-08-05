import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_time.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/role_single.dart';
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

    if (!target.hasWolfRole()) {
      (owner as RoleSingular).player.addStatusEffect(HuntStatusEffect(owner));
    }
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
  bool shouldBeAvailable() {
    return (owner.player as Player).hasFatalEffect();
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was killed.';

    return '${targets[0].name} has been killed.';
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return owner.playerIsFatallyWounded();
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return true;
  }
}

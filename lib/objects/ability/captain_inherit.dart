import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/inherit_effect.dart';

class InheritAbility extends Ability {
  InheritAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.inherit;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.both;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(InheritCaptaincyStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return !target.hasFatalEffect();
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
    if (targets.isEmpty) {
      return 'No body was designed to inherit the captaincy.';
    }

    return '${targets[0].name} has been executed';
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {
    if (affected.isEmpty) return;

    game.replaceCaptainPlayer(affected[0]);
  }

  @override
  bool isUnskippable() {
    return owner.playerIsFatallyWounded();
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return true;
  }
}

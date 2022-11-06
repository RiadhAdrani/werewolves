import 'package:werewolves/constants/roles.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/father_infect_effect.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

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
    target.removeEffectsOfType(StatusEffectType.isDevoured);
    target.addStatusEffect(InfectStatusEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target.hasEffect(StatusEffectType.isDevoured) &&
        !target.hasWolfRole();
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
    if (targets.isEmpty) return 'No body was infected.';

    return '${targets[0].name} has been infected and will join the Wolfpack.';
  }

  @override
  void usePostEffect(GameModel game, List<Player> affected) {
    if (affected.isEmpty) return;

    var newMember = affected[0];

    if (Wolfpack.shouldJoinWolfpackUponInfection(newMember)) {
      newMember.team = Team.wolves;
    }

    game.addMemberToGroup(newMember, RoleId.wolfpack);
  }

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

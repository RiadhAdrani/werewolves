// ignore: implementation_imports
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Wolfpack extends RoleGroup {
  Wolfpack(super.player) {
    callingPriority = wolfpackPriority;
    abilities = [DevourAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.wolfpack;
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return true;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return hasAtLeastOneSurvivingMember();
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return ['Assemble wolfpack.', 'Choose your victim.'];
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }
}

class DevouredEffect extends Effect {
  DevouredEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isDevoured;
  }
}

class DevourAbility extends Ability {
  DevourAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.devour;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(DevouredEffect(owner));
  }

  @override
  bool isTarget(Player target, int turn) {
    return true;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return !target.hasEffect(EffectId.isProtected);
  }

  @override
  bool shouldBeAvailable() {
    return true;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

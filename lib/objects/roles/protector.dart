// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

class Protector extends RoleSingular {
  Protector(super.player) {
    id = RoleId.protector;
    callingPriority = protectorPriority;
    abilities = [ProtectAbility(this)];
  }

  @override
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return true;
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
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    final output = <String>[
      'Choose a target to protect with your shield.',
      'The chosen target will be immune to the strikes of the wolves.'
    ];

    List<Player> protected = getPlayersWithEffects(
      usePlayerExtractor(roles),
      [EffectId.wasProtected],
    );

    if (protected.isNotEmpty) {
      output.add('You cannot protect (${protected[0].name}) in this night.');
    }

    return output;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

class ProtectedEffect extends Effect {
  ProtectedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isProtected;
  }
}

class WasProtectedEffect extends Effect {
  WasProtectedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.wasProtected;
  }
}

class ProtectAbility extends Ability {
  ProtectAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.protect;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addEffect(ProtectedEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return !target.hasEffect(EffectId.wasProtected);
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
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }
}

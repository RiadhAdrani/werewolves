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
  bool shouldBeCalledAtNight(Game game) {
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
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    final output = <String>[
      'Choose a target to protect with your shield.',
      'The chosen target will be immune to the strikes of the wolves.'
    ];

    List<Player> protected =
        game.getPlayersWithStatusEffects([EffectId.wasProtected]);

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
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was protected.';

    return '${targets[0].name} is protected.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

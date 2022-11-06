// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/widgets/alert/game_confirm_ability_use.dart';

class Captain extends RoleSingular {
  Captain(super.player) {
    id = RoleId.captain;
    callingPriority = captainCallPriority;

    super.abilities = [
      ExecuteAbility(this),
      SubstitueAbility(this),
      TalkerAbility(this),
      InheritAbility(this)
    ];
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
  bool shouldBeCalledAtNight(Game game) {
    return true;
  }

  @override
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    final output = <String>[];

    if (player.hasFatalEffect()) {
      output.add(
          'You are dead, choose another fellow player to inherit your capitaincy.');
    }

    output.add('Choose a player whom will start the discussion.');

    return output;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return true;
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    /// Check for servant effect.
    /// We do not pass the captaincy to the servant
    /// if he is not a captain mainly,
    /// the servant should get the secondary role.
    /// We leave the inheritance to the dead captain.
    if (player.getMainRole() == this &&
        player.hasFatalEffect() == true &&
        player.hasEffect(EffectId.isServed)) {
      var servant = gameModel.getRole(RoleId.servant);

      if (servant == null) {
        return false;
      }

      if (servant.isObsolete()) {
        return false;
      }

      gameModel.onServedDeath(this, () {
        showConfirmAlert("Captain inheritance",
            'The servant became the new captain.', context, () {
          if (gameModel.state == GameState.night) {
            gameModel.skipCurrentRole(context);
          }
        });

        return true;
      });
    }

    return false;
  }
}

class ExecutedEffect extends Effect {
  ExecutedEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isExecuted;
  }
}

class InheritCaptaincyEffect extends Effect {
  InheritCaptaincyEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.hasInheritedCaptaincy;
  }
}

class SubstitueEffect extends Effect {
  SubstitueEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.isSubstitue;
  }
}

class TalkerEffect extends Effect {
  TalkerEffect(Role source) {
    this.source = source;
    permanent = false;
    type = EffectId.shouldTalkFirst;
  }
}

class ExecuteAbility extends Ability {
  ExecuteAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.execute;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.day;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(ExecutedEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return true;
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
    if (targets.isEmpty) return 'No body was designed to be executed.';

    return '${targets[0].name} is executed.';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

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
    target.addStatusEffect(InheritCaptaincyEffect(owner));
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
  void usePostEffect(Game game, List<Player> affected) {
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

class SubstitueAbility extends Ability {
  SubstitueAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.substitute;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(SubstitueEffect(owner));
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
    return false;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) {
      return 'No body was designed to substitue the captain.';
    }

    return '${targets[0].name} has been executed';
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}

  @override
  bool isUnskippable() {
    return false;
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
    return false;
  }
}

class TalkerAbility extends Ability {
  TalkerAbility(Role owner) {
    super.targetCount = 1;
    super.name = AbilityId.talker;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.infinite;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    target.addStatusEffect(TalkerEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return true;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.player as Player).hasFatalEffect();
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    if (targets.isEmpty) return 'No body was designed to start the discussion';

    return '${targets[0].name} shall start the discussion.';
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

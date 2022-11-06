// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/roles.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/captain_execute.dart';
import 'package:werewolves/objects/ability/captain_inherit.dart';
import 'package:werewolves/objects/ability/captain_substitue.dart';
import 'package:werewolves/objects/ability/captain_talker.dart';
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
  bool shouldBeCalledAtNight(GameModel game) {
    return true;
  }

  @override
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
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
  Teams getSupposedInitialTeam() {
    return Teams.village;
  }

  @override
  bool beforeCallEffect(BuildContext context, GameModel gameModel) {
    /// Check for servant effect.
    /// We do not pass the captaincy to the servant
    /// if he is not a captain mainly,
    /// the servant should get the secondary role.
    /// We leave the inheritance to the dead captain.
    if (player.getMainRole() == this &&
        player.hasFatalEffect() == true &&
        player.hasEffect(StatusEffectType.isServed)) {
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
          if (gameModel.getState() == GameState.night) {
            gameModel.skipCurrentRole(context);
          }
        });

        return true;
      });
    }

    return false;
  }
}

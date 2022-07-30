import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/constants/teams.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/protector_protect.dart';

class Protector extends RoleSingular {
  Protector(super.player) {
    id = RoleId.protector;
    callingPriority = protectorCallPriority;
    abilities = [ProtectAbility(this)];
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
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
  List<String> getAdvices(GameModel game) {
    return [];
  }

  @override
  List<String> getInformations(GameModel game) {
    final output = <String>[
      'Choose a target to protect with your shield.',
      'The chosen target will be immune to the strikes of the wolves.'
    ];

    List<Player> protected =
        game.getPlayersWithStatusEffects([StatusEffectType.wasProtected]);

    if (protected.isNotEmpty) {
      output
          .add('You cannot protect (${protected[0].getName()}) in this night.');
    }

    return output;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  Teams getSupposedInitialTeam() {
    return Teams.village;
  }
}

import 'package:werewolves/constants/role_call_priority.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/objects/ability/hunter_callsign.dart';
import 'package:werewolves/objects/ability/hunter_hunt.dart';

class Hunter extends RoleSingular {
  Hunter(super.player) {
    id = RoleId.hunter;
    callingPriority = hunterCallPriority;
    abilities = [
      CallSignAbility(this),
      HuntAbility(this),
    ];
  }

  @override
  bool canUseAbilities() {
    return player.hasFatalEffect() || !player.hasEffect(StatusEffectType.hasCallsign);
  }

  @override
  bool canUseSignWithNarrator() {
    return true;
  }

  @override
  bool shouldBeCalledAtNight(GameModel game) {
    return player.hasFatalEffect() || !player.hasEffect(StatusEffectType.hasCallsign);
  }
}

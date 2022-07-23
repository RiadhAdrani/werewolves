import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

class Ability {
  late AbilityId name;
  late int targetCount;
  late AbilityType type;
  late AbilityUseCount useCount;
  late Function call;
  late Function checkShouldBeUsedOnPassive = () {
    return false;
  };
  late Function checkIsTarget = () {
    return true;
  };
  late Function checkCanUseAbility = () {
    return true;
  };

  Ability(
      this.name,
      this.targetCount,
      this.type,
      this.useCount,
      this.call,
      this.checkCanUseAbility,
      this.checkIsTarget,
      this.checkShouldBeUsedOnPassive);

  void use(Role owner,List<Player> targets) {
    if (checkCanUseAbility(owner) && useCount != AbilityUseCount.none){
      call(targets);
    }
  }
}

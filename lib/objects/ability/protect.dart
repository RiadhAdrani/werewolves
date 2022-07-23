import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/ability_type.dart';
import 'package:werewolves/constants/ability_use_count.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/objects/roles/protector.dart';

Ability protectAbility(Protector role) {
  return Ability(
    AbilityId.protect,
    1,
    AbilityType.active,
    AbilityUseCount.infinite,
    // call
    (){}, 
    // check can use ability
    (){}, 
     // check is target
    (){},
    // check should be used on passive
    (){} 
    );
}

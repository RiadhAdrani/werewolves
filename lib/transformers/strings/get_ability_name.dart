import 'package:werewolves/constants/ability_id.dart';

String getAbilityName(AbilityId id) {
  switch (id) {
    case AbilityId.protect:
      return "Protect";
    case AbilityId.devour:
      return "Devour";
    case AbilityId.infect:
      return "Infect";
    case AbilityId.clairvoyance:
      return "Clairvoyance";
    case AbilityId.revive:
      return "Revive";
    case AbilityId.curse:
      return "Curse";
    case AbilityId.counter:
      return "Counter";
    case AbilityId.hunt:
      return "Hunt";
    case AbilityId.order:
      return "Order";
    case AbilityId.execute:
      return "Execute";
    case AbilityId.substitute:
      return "Substitue";
    case AbilityId.inherit:
      return "Inherit";
  }
}

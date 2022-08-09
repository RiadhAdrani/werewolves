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
    case AbilityId.talker:
      return "Order";
    case AbilityId.execute:
      return "Execute";
    case AbilityId.substitute:
      return "Substitue";
    case AbilityId.inherit:
      return "Inherit";
    case AbilityId.callsign:
      return "Call sign";
    case AbilityId.serve:
      return "Serve";
    case AbilityId.judgement:
      return "Judge";
    case AbilityId.mute:
      return "Mute";
  }
}

import 'package:werewolves/constants/role_id.dart';

String getRoleName(RoleId role) {
  switch (role) {
    case RoleId.protector:
      return "Protector";
    case RoleId.werewolves:
      return "Werewolf";
    case RoleId.fatherOfWolves:
      return "Infect, Father of wolves";
    case RoleId.witch:
      return "Witch";
    case RoleId.seer:
      return "Seer";
    case RoleId.knight:
      return "Knight";
    case RoleId.hunter:
      return "Hunter";
    case RoleId.captain:
      return "Captain";
    case RoleId.villager:
      return "Villager";
  }
}

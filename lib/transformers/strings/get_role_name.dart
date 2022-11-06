import 'package:werewolves/models/role.dart';

String getRoleName(RoleId role) {
  switch (role) {
    case RoleId.protector:
      return "Protector";
    case RoleId.werewolf:
      return "Werewolf";
    case RoleId.fatherOfWolves:
      return "Father of wolves";
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
    case RoleId.wolfpack:
      return "Wolfpack";
    case RoleId.servant:
      return "Servant";
    case RoleId.judge:
      return "Judge";
    case RoleId.blackWolf:
      return "Black Wolf";
    case RoleId.garrulousWolf:
      return 'Garrulous Wolf';
    case RoleId.shepherd:
      return 'Shepherd';
    case RoleId.alien:
      return "Alien";
  }
}

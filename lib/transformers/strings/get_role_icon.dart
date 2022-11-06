import 'package:werewolves/constants/roles.dart';

String base(String icon) {
  return 'assets/$icon.png';
}

String getRoleIconPath(RoleId role) {
  switch (role) {
    case RoleId.protector:
      return base('protector');
    case RoleId.werewolf:
      return base('werewolf');
    case RoleId.fatherOfWolves:
      return base('father_wolf');
    case RoleId.witch:
      return base('witch');
    case RoleId.seer:
      return base('seer');
    case RoleId.knight:
      return base('knight');
    case RoleId.hunter:
      return base('hunter');
    case RoleId.captain:
      return base('captain');
    case RoleId.villager:
      return base('simple_villager');
    case RoleId.wolfpack:
      return base('werewolf');
    case RoleId.servant:
      return base('simple_villager');
    case RoleId.judge:
      return base('simple_villager');
    case RoleId.blackWolf:
      return base('werewolf');
    case RoleId.garrulousWolf:
      return base('werewolf');
    case RoleId.shepherd:
      return base('simple_villager');
    case RoleId.alien:
      return base('simple_villager');
  }
}

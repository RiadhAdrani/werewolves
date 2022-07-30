import 'package:werewolves/constants/role_id.dart';

String base(String icon) {
  return 'assets/$icon.png';
}

String getRoleIconPath(RoleId role) {
  switch (role) {
    case RoleId.protector:
      return base('protector');
    case RoleId.werewolves:
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
  }
}

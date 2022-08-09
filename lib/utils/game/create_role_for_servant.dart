import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';

Role createRoleForServant(Role oldRole, Player servantPlayer) {
  Player dummy = Player('placeholder');
  Role role = Villager(dummy);

  switch (oldRole.id) {
    case RoleId.protector:
      role = Protector(dummy);
      break;
    case RoleId.werewolf:
      role = Werewolf(dummy);
      break;
    case RoleId.fatherOfWolves:
      role = FatherOfWolves(dummy);
      break;
    case RoleId.witch:
      role = Witch(dummy);
      break;
    case RoleId.seer:
      role = Seer(dummy);
      break;
    case RoleId.knight:
      role = Knight(dummy);
      break;
    case RoleId.hunter:
      role = Hunter(dummy);
      break;
    case RoleId.captain:
      role = Captain(dummy);
      break;
    case RoleId.villager:
      role = Villager(dummy);
      break;
    case RoleId.wolfpack:
      role = Werewolf(dummy);
      break;
    case RoleId.servant:
      break;
    case RoleId.judge:
      role = Judge(dummy);
      break;
    case RoleId.blackWolf:
      role = BlackWolf(dummy);
      break;
  }

  role.player = servantPlayer;
  role.callingPriority += 1;

  return role;
}

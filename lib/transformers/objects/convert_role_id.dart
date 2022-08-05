import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/servant.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';

List<Role> makeListFromId(List<RoleId> listOfUid) {
  final list = <Role>[];

  final player = Player("dummy Player");

  for (var element in listOfUid) {
    switch (element) {
      case RoleId.protector:
        list.add(Protector(player));
        break;
      case RoleId.werewolf:
        list.add(Werewolf(player));
        break;
      case RoleId.fatherOfWolves:
        list.add(FatherOfWolves(player));
        break;
      case RoleId.witch:
        list.add(Witch(player));
        break;
      case RoleId.seer:
        list.add(Seer(player));
        break;
      case RoleId.knight:
        list.add(Knight(player));
        break;
      case RoleId.hunter:
        list.add(Hunter(player));
        break;
      case RoleId.captain:
        list.add(Captain(player));
        break;
      case RoleId.villager:
        list.add(Villager(player));
        break;
      case RoleId.wolfpack:
        break;
      case RoleId.servant:
        list.add(Servant(player));
        break;
      case RoleId.judge:
        list.add(Judge(player));
        break;
    }
  }

  return list;
}

List<RoleId> makeSerializableListOfRoles(List<Role> listOfRoles) {
  return listOfRoles.map((e) => e.id).toList();
}

import 'package:werewolves/constants/roles.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/alien.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/garrulous_wolf.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';

List<Role> makeAvailableList() {
  Player player() => Player("Placeholder_Player");

  List<Role> output = [];

  for (var element in RoleId.values) {
    switch (element) {
      case RoleId.protector:
        output.add(Protector(player()));
        break;
      case RoleId.werewolf:
        output.add(Werewolf(player()));
        break;
      case RoleId.fatherOfWolves:
        output.add(FatherOfWolves(player()));
        break;
      case RoleId.witch:
        output.add(Witch(player()));
        break;
      case RoleId.seer:
        output.add(Seer(player()));
        break;
      case RoleId.knight:
        output.add(Knight(player()));
        break;
      case RoleId.hunter:
        output.add(Hunter(player()));
        break;
      case RoleId.captain:
        output.add(Captain(player()));
        break;
      case RoleId.villager:
        output.add(Villager(player()));
        break;
      case RoleId.judge:
        output.add(Judge(player()));
        break;
      case RoleId.blackWolf:
        output.add(BlackWolf(player()));
        break;
      case RoleId.garrulousWolf:
        output.add(GarrulousWolf(player()));
        break;
      case RoleId.shepherd:
        output.add(Shepherd(player()));
        break;
      case RoleId.alien:
        output.add(Alien(player()));
        break;

      /// Not ready for production -------------------------------------------
      case RoleId.servant:
        break;

      /// Group roles --------------------------------------------------------
      /// Will be injected automatically later,
      /// when roles have been distributed.
      case RoleId.wolfpack:
        break;
    }
  }

  return output;
}

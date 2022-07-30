import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';

List<Role> makeAvailableList() {

  Player player () => Player("Placeholder_Player");

  return [
    Captain(player()),
    FatherOfWolves(player()),
    Hunter(player()),
    Knight(player()),
    Protector(player()),
    Seer(player()),
    Villager(player()),
    Werewolf(player()),
    Witch(player())
  ];
}

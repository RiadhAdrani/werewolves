import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

bool checkPlayerName(String name, List<Role> list) {
  if (name.trim().isEmpty) return false;

  if (name.trim().length < 3) return false;

  for (var i = 0; i < list.length; i++) {
    if (list[i].player is Player &&
        list[i].player.name.toString().trim().toLowerCase() == name.trim().toLowerCase()) {
          return false;
      }
  }

  return true;
}

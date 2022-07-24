import 'package:werewolves/models/role.dart';

bool checkPlayerName(String name, List<Role> list) {
  if (name.trim().isEmpty) return false;

  if (name.trim().length < 3) return false;

  return true;
}

import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

Role resolveSeenRole(Player player) {
  return player.getMainRole();
}

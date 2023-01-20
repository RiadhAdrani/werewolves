import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/villager.dart';

Player createPlayer({
  List<RoleId> roles = const [RoleId.villager],
  List<EffectId> effects = const [],
  Player? effectSource,
}) {
  Player player = Player('test');

  for (var id in roles) {
    createRoleFromId(id, player);
  }

  for (var id in effects) {
    player.addEffect(createEffectFromId(id, Villager(Player('dummy'))));
  }

  return player;
}

Role createRole({
  RoleId id = RoleId.villager,
  List<AbilityId> abilities = const [],
}) {
  Role role = createRoleFromId(id, Player('test'));

  for (var ability in abilities) {
    role.abilities.add(createAbilityFromId(ability, role));
  }

  return role;
}

Role? findFirstRoleOfType(List<Role> roles, RoleId id) {
  return roles.firstWhere(
    (element) => element.id == id,
    orElse: () => null as Role,
  );
}

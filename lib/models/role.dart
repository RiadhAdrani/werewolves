import 'package:uuid/uuid.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/transformers/strings/get_role_name.dart';

const uuid = Uuid();

abstract class Role<T> {
  late T player;

  RoleId id = RoleId.villager;
  String instanceId = uuid.v4();

  int callingPriority = -1;

  List<Ability> abilities = [];

  bool isWolf = false;

  bool isGroupRole = false;

  Role(this.player);

  String getName() {
    return getRoleName(id);
  }

  bool shouldBeCalledAtNight(GameModel game);

  bool canUseAbilities();

  bool canUseSignWithNarrator();

  String getPlayerName();
}

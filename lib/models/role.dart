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

  T getPlayer() {
    return player;
  }

  /// Get the name of the role
  String getName() {
    return getRoleName(id);
  }

  /// Check if the role is meant to be treated as a group.
  bool isGroup() {
    return isGroupRole;
  }

  /// Should the role be called during the night.
  bool shouldBeCalledAtNight(GameModel game);

  /// Can the role use its abilities
  bool canUseAbilities();

  /// Can the role use signs to communicate with the narrator during the dary.
  bool canUseSignWithNarrator();

  /// Get the name of the player that will be displayed.
  String getPlayerName();

  /// Override the associated player.
  void setPlayer(T player);

  /// Check if the player `isAlive` equals false.
  /// `isAlive` is updated between phases, and not during the night,
  /// except by a dead captain.
  bool isObsolete();

  /// Check if the player has been affected by a fatal status effect.
  /// Used to check is primarily dead during the night.
  bool playerIsFatallyWounded();

  /// Get the informations that the role needs to know.
  List<String> getInformations(GameModel game);

  /// Get the instructions ,advices and tips for the narrator.
  List<String> getAdvices(GameModel game);
}

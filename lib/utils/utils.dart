import 'package:uuid/uuid.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';

const uuid = Uuid();

String useId() {
  return uuid.v4();
}

String ellipsify(String str, int max) {
  return str.length > max ? "${str.substring(0, max)}..." : str;
}

bool checkPlayerName(String name, List<Role> list) {
  if (name.trim().isEmpty) return false;

  if (name.trim().length < 3) return false;

  RegExp validator = RegExp(r'^[a-zA-Z0-9 ]+$');

  if (!validator.hasMatch(name)) {
    return false;
  }

  for (var i = 0; i < list.length; i++) {
    if (list[i].player is Player &&
        list[i].player.id.toString().trim().toLowerCase() ==
            name.trim().toLowerCase()) {
      return false;
    }
  }

  return true;
}

String appendPluralS(int number) {
  return number > 1 ? 's' : '';
}

class Validation {
  String? msg;
  late bool valid;

  Validation(this.valid, {this.msg});
}

Validation isSelectionValid(List<RoleId> roles) {
  // ? minimum allowed is 7
  if (roles.length < 7) {
    return Validation(
      false,
      msg: 'Player count is too low',
    );
  }

  // ? the number of wolves should not exceed the number of villagers
  var villagersCount =
      roles.where((id) => !useRole(id).isSolo && !useRole(id).isWolf).length;
  var wolvesCount =
      roles.where((id) => !useRole(id).isSolo && useRole(id).isWolf).length;

  // ? there should be at least one wolf
  if (wolvesCount == 0) {
    return Validation(
      false,
      msg: 'At least one wolf should be present.',
    );
  }

  if (wolvesCount >= villagersCount) {
    return Validation(
      false,
      msg: 'Wolves count is higher than the villagers count',
    );
  }

  // ? solos count should not be higher or equal to the number of villagers or wolves.
  var solosCount = roles.where((id) => useRole(id).isSolo).length;

  if (solosCount >= villagersCount) {
    return Validation(
      false,
      msg: 'Solos count is higher than the villagers count',
    );
  }

  if (solosCount >= wolvesCount) {
    return Validation(
      false,
      msg: 'Solos count is higher than the wolves count',
    );
  }

  return Validation(true);
}

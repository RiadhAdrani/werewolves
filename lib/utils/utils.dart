import 'package:uuid/uuid.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/i18n/keys.dart';
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
    if (list[i].controller is Player &&
        list[i].controller.id.toString().trim().toLowerCase() ==
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
      msg: t(LK.selectPlayerCountLow),
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
      msg: t(LK.selectAtLeastOneWolf),
    );
  }

  if (wolvesCount >= villagersCount) {
    return Validation(
      false,
      msg: t(LK.selectWolvesCountHigherVillagers),
    );
  }

  // ? solos count should not be higher or equal to the number of villagers or wolves.
  var solosCount = roles.where((id) => useRole(id).isSolo).length;

  if (solosCount >= villagersCount) {
    return Validation(
      false,
      msg: t(LK.selectSolosCountHigherVillagers),
    );
  }

  if (solosCount >= wolvesCount) {
    return Validation(
      false,
      msg: t(LK.selectSolosCountHigherWolves),
    );
  }

  return Validation(true);
}

import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';
import 'package:werewolves/objects/effects/guessed_effect.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/garrulous_wolf.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/servant.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/witch.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

abstract class Effect {
  late EffectId type;
  late Role source;
  late bool permanent;
}

enum EffectId {
  isProtected,
  isDevoured,
  isInfected,
  isCursed,
  isRevived,
  isSeen,
  isCountered,
  isHunted,
  isExecuted,
  isSubstitue,
  isServed,
  isServing,
  isJudged,
  isMuted,
  isGuessedByAlien,

  wasMuted,
  wasProtected,
  wasJudged,

  hasCallsign,
  hasInheritedCaptaincy,
  hasSheep,

  shouldTalkFirst,
  hasWord,
}

const List<EffectId> fatalStatusEffects = [
  EffectId.isCursed,
  EffectId.isDevoured,
  EffectId.isHunted,
  EffectId.isCountered,
  EffectId.isExecuted,
  EffectId.isGuessedByAlien
];

bool isFatalEffect(EffectId effect) {
  return fatalStatusEffects.contains(effect);
}

class EffectHelperObject {
  late String asString;
  late String description;
  late Effect Function(Role source) create;

  EffectHelperObject(
    this.asString,
    this.description,
    this.create,
  );
}

EffectHelperObject useEffectHelper(EffectId id) {
  switch (id) {
    case EffectId.isProtected:
      return EffectHelperObject(
        'isProtected',
        'description',
        (source) => ProtectedEffect(source),
      );
    case EffectId.isDevoured:
      return EffectHelperObject(
        'isDevoured',
        'description',
        (source) => DevouredEffect(source),
      );
    case EffectId.isInfected:
      return EffectHelperObject(
        'isInfected',
        'description',
        (source) => InfectedEffect(source),
      );
    case EffectId.isCursed:
      return EffectHelperObject(
        'isCursed',
        'description',
        (source) => CursedEffect(source),
      );
    case EffectId.isRevived:
      return EffectHelperObject(
        'isRevived',
        'description',
        (source) => RevivedEffect(source),
      );
    case EffectId.isSeen:
      return EffectHelperObject(
        'isSeen',
        'description',
        (source) => ClairvoyanceEffect(source),
      );
    case EffectId.isCountered:
      return EffectHelperObject(
        'isCountered',
        'description',
        (source) => CounteredEffect(source),
      );
    case EffectId.isHunted:
      return EffectHelperObject(
        'isHunted',
        'description',
        (source) => HuntedEffect(source),
      );
    case EffectId.isExecuted:
      return EffectHelperObject(
        'isExecuted',
        'description',
        (source) => ExecutedEffect(source),
      );
    case EffectId.isSubstitue:
      return EffectHelperObject(
        'isSubstitue',
        'description',
        (source) => SubstitutedEffect(source),
      );
    case EffectId.isServed:
      return EffectHelperObject(
        'isServed',
        'description',
        (source) => ServedEffect(source),
      );
    case EffectId.isServing:
      return EffectHelperObject(
        'isServing',
        'description',
        (source) => BeingServedEffect(source),
      );
    case EffectId.isJudged:
      return EffectHelperObject(
        'isJudged',
        'description',
        (source) => JudgedEffect(source),
      );
    case EffectId.isMuted:
      return EffectHelperObject(
        'isMuted',
        'description',
        (source) => MutedEffect(source),
      );
    case EffectId.isGuessedByAlien:
      return EffectHelperObject(
        'isGuessedByAlien',
        'description',
        (source) => GuessedByAlienEffect(source),
      );
    case EffectId.wasMuted:
      return EffectHelperObject(
        'wasMuted',
        'description',
        (source) => WasMutedEffect(source),
      );
    case EffectId.wasProtected:
      return EffectHelperObject(
        'WasProtect',
        'description',
        (source) => WasProtectedEffect(source),
      );
    case EffectId.wasJudged:
      return EffectHelperObject(
        'wasProtect',
        'description',
        (source) => WasJudgedEffect(source),
      );
    case EffectId.hasCallsign:
      return EffectHelperObject(
        'hasCallSign',
        'description',
        (source) => HasCallSignEffect(source),
      );
    case EffectId.hasInheritedCaptaincy:
      return EffectHelperObject(
        'hasInheritedCaptaincy',
        'description',
        (source) => InheritedCaptaincyEffect(source),
      );
    case EffectId.hasSheep:
      return EffectHelperObject(
        'hasSheep',
        'description',
        (source) => HasSheepEffect(source),
      );
    case EffectId.shouldTalkFirst:
      return EffectHelperObject(
        'shouldTalkFirst',
        'description',
        (source) => ShouldTalkFirstEffect(source),
      );
    case EffectId.hasWord:
      return EffectHelperObject(
        'hasWord',
        'description',
        (source) => HasWordEffect(source),
      );
  }
}

String effectIdToString(EffectId effect) {
  return useEffectHelper(effect).asString;
}

Effect createEffectFromId(EffectId id, Role owner) {
  return useEffectHelper(id).create(owner);
}

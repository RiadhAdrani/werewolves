import 'package:werewolves/app/app.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';
import 'package:werewolves/objects/roles/alien.dart';
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
  late Role source;

  EffectId get id {
    throw 'Not implemented';
  }

  bool get isPermanent {
    return false;
  }
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

  @Deprecated('Do not use !')
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
        t(LK.isProtected),
        t(LK.isProtectedDescription),
        (source) => ProtectedEffect(source),
      );
    case EffectId.isDevoured:
      return EffectHelperObject(
        t(LK.isDevoured),
        t(LK.isDevouredDescription),
        (source) => DevouredEffect(source),
      );
    case EffectId.isInfected:
      return EffectHelperObject(
        t(LK.isInfected),
        t(LK.isInfectedDescription),
        (source) => InfectedEffect(source),
      );
    case EffectId.isCursed:
      return EffectHelperObject(
        t(LK.isCursed),
        t(LK.isCursedDescription),
        (source) => CursedEffect(source),
      );
    case EffectId.isRevived:
      return EffectHelperObject(
        t(LK.isRevived),
        t(LK.isRevivedDescription),
        (source) => RevivedEffect(source),
      );
    case EffectId.isSeen:
      return EffectHelperObject(
        t(LK.isSeen),
        t(LK.isSeenDescription),
        (source) => ClairvoyanceEffect(source),
      );
    case EffectId.isCountered:
      return EffectHelperObject(
        t(LK.isCountered),
        t(LK.isCounteredDescription),
        (source) => CounteredEffect(source),
      );
    case EffectId.isHunted:
      return EffectHelperObject(
        t(LK.isHunted),
        t(LK.isHuntedDescription),
        (source) => HuntedEffect(source),
      );
    case EffectId.isExecuted:
      return EffectHelperObject(
        t(LK.isExecuted),
        t(LK.isExecutedDescription),
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
        (source) => ServingEffect(source),
      );
    case EffectId.isJudged:
      return EffectHelperObject(
        t(LK.isJudged),
        t(LK.isJudgedDescription),
        (source) => JudgedEffect(source),
      );
    case EffectId.isMuted:
      return EffectHelperObject(
        t(LK.isMuted),
        t(LK.isMutedDescription),
        (source) => MutedEffect(source),
      );
    case EffectId.isGuessedByAlien:
      return EffectHelperObject(
        t(LK.isGuessedByAlien),
        t(LK.isGuessedByAlienDescription),
        (source) => GuessedByAlienEffect(source),
      );
    case EffectId.wasMuted:
      return EffectHelperObject(
        t(LK.wasMuted),
        t(LK.wasMutedDescription),
        (source) => WasMutedEffect(source),
      );
    case EffectId.wasProtected:
      return EffectHelperObject(
        t(LK.wasProtected),
        t(LK.wasProtectedDescription),
        (source) => WasProtectedEffect(source),
      );
    case EffectId.wasJudged:
      return EffectHelperObject(
        t(LK.wasJudged),
        t(LK.wasJudgedDescription),
        (source) => WasJudgedEffect(source),
      );
    case EffectId.hasCallsign:
      return EffectHelperObject(
        t(LK.hasCallsign),
        t(LK.hasCallsignDescription),
        (source) => HasCallSignEffect(source),
      );
    case EffectId.hasInheritedCaptaincy:
      return EffectHelperObject(
        t(LK.hasInheritedCaptaincy),
        t(LK.hasInheritedCaptaincyDescription),
        (source) => InheritedCaptaincyEffect(source),
      );
    case EffectId.hasSheep:
      return EffectHelperObject(
        t(LK.hasSheep),
        t(LK.hasSheepDescription),
        (source) => HasSheepEffect(source),
      );
    case EffectId.shouldTalkFirst:
      return EffectHelperObject(
        t(LK.shouldTalkFirst),
        t(LK.shouldTalkFirstDescription),
        (source) => ShouldTalkFirstEffect(source),
      );
    case EffectId.hasWord:
      return EffectHelperObject(
        t(LK.hasWord),
        t(LK.hasWordDescription),
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

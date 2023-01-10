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
        t(LKey.isProtected),
        t(LKey.isProtectedDescription),
        (source) => ProtectedEffect(source),
      );
    case EffectId.isDevoured:
      return EffectHelperObject(
        t(LKey.isDevoured),
        t(LKey.isDevouredDescription),
        (source) => DevouredEffect(source),
      );
    case EffectId.isInfected:
      return EffectHelperObject(
        t(LKey.isInfected),
        t(LKey.isInfectedDescription),
        (source) => InfectedEffect(source),
      );
    case EffectId.isCursed:
      return EffectHelperObject(
        t(LKey.isCursed),
        t(LKey.isCursedDescription),
        (source) => CursedEffect(source),
      );
    case EffectId.isRevived:
      return EffectHelperObject(
        t(LKey.isRevived),
        t(LKey.isRevivedDescription),
        (source) => RevivedEffect(source),
      );
    case EffectId.isSeen:
      return EffectHelperObject(
        t(LKey.isSeen),
        t(LKey.isSeenDescription),
        (source) => ClairvoyanceEffect(source),
      );
    case EffectId.isCountered:
      return EffectHelperObject(
        t(LKey.isCountered),
        t(LKey.isCounteredDescription),
        (source) => CounteredEffect(source),
      );
    case EffectId.isHunted:
      return EffectHelperObject(
        t(LKey.isHunted),
        t(LKey.isHuntedDescription),
        (source) => HuntedEffect(source),
      );
    case EffectId.isExecuted:
      return EffectHelperObject(
        t(LKey.isExecuted),
        t(LKey.isExecutedDescription),
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
        t(LKey.isJudged),
        t(LKey.isJudgedDescription),
        (source) => JudgedEffect(source),
      );
    case EffectId.isMuted:
      return EffectHelperObject(
        t(LKey.isMuted),
        t(LKey.isMutedDescription),
        (source) => MutedEffect(source),
      );
    case EffectId.isGuessedByAlien:
      return EffectHelperObject(
        t(LKey.isGuessedByAlien),
        t(LKey.isGuessedByAlienDescription),
        (source) => GuessedByAlienEffect(source),
      );
    case EffectId.wasMuted:
      return EffectHelperObject(
        t(LKey.wasMuted),
        t(LKey.wasMutedDescription),
        (source) => WasMutedEffect(source),
      );
    case EffectId.wasProtected:
      return EffectHelperObject(
        t(LKey.wasProtected),
        t(LKey.wasProtectedDescription),
        (source) => WasProtectedEffect(source),
      );
    case EffectId.wasJudged:
      return EffectHelperObject(
        t(LKey.wasJudged),
        t(LKey.wasJudgedDescription),
        (source) => WasJudgedEffect(source),
      );
    case EffectId.hasCallsign:
      return EffectHelperObject(
        t(LKey.hasCallsign),
        t(LKey.hasCallsignDescription),
        (source) => HasCallSignEffect(source),
      );
    case EffectId.hasInheritedCaptaincy:
      return EffectHelperObject(
        t(LKey.hasInheritedCaptaincy),
        t(LKey.hasInheritedCaptaincyDescription),
        (source) => InheritedCaptaincyEffect(source),
      );
    case EffectId.hasSheep:
      return EffectHelperObject(
        t(LKey.hasSheep),
        t(LKey.hasSheepDescription),
        (source) => HasSheepEffect(source),
      );
    case EffectId.shouldTalkFirst:
      return EffectHelperObject(
        t(LKey.shouldTalkFirst),
        t(LKey.shouldTalkFirstDescription),
        (source) => ShouldTalkFirstEffect(source),
      );
    case EffectId.hasWord:
      return EffectHelperObject(
        t(LKey.hasWord),
        t(LKey.hasWordDescription),
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

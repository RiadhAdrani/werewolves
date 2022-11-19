import 'package:werewolves/models/role.dart';

class Effect {
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
  shouldSayTheWord,
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

String effectIdToString(EffectId effect) {
  switch (effect) {
    case EffectId.isProtected:
      return 'isProtected';
    case EffectId.wasProtected:
      return 'wasProtected';
    case EffectId.isDevoured:
      return 'isDevoured';
    case EffectId.isInfected:
      return 'isInfected';
    case EffectId.isCursed:
      return 'isCursed';
    case EffectId.isRevived:
      return 'isRevived';
    case EffectId.isSeen:
      return 'isSeen';
    case EffectId.isCountered:
      return 'isCountered';
    case EffectId.isHunted:
      return 'isHunted';
    case EffectId.isExecuted:
      return 'isExecuted';
    case EffectId.isSubstitue:
      return 'isSubstitution';
    case EffectId.isServed:
      return 'isServed';
    case EffectId.isServing:
      return 'isServing';
    case EffectId.isJudged:
      return 'isJudged';
    case EffectId.isMuted:
      return 'isMuted';
    case EffectId.wasMuted:
      return 'wasMuted';
    case EffectId.wasJudged:
      return 'wasJudged';
    case EffectId.hasCallsign:
      return 'hasCallsign';
    case EffectId.hasInheritedCaptaincy:
      return 'hasInheritedCaptaincy';
    case EffectId.shouldTalkFirst:
      return 'shouldTalkFirst';
    case EffectId.shouldSayTheWord:
      return 'shouldSayTheWord';
    case EffectId.hasSheep:
      return "hasSheep";
    case EffectId.isGuessedByAlien:
      return "isGuessed";
  }
}

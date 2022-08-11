enum StatusEffectType {
  isProtected,
  wasProtected,
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
  wasMuted,
  wasJudged,
  hasCallsign,
  hasInheritedCaptaincy,
  shouldTalkFirst,
  shouldSayTheWord,
  hasSheep
}

const List<StatusEffectType> fatalStatusEffects = [
  StatusEffectType.isCursed,
  StatusEffectType.isDevoured,
  StatusEffectType.isHunted,
  StatusEffectType.isCountered,
  StatusEffectType.isExecuted
];

bool isFatalEffect(StatusEffectType effect) {
  return fatalStatusEffects.contains(effect);
}

String statusEffectTypeToString(StatusEffectType effect) {
  switch (effect) {
    case StatusEffectType.isProtected:
      return 'isProtected';
    case StatusEffectType.wasProtected:
      return 'wasProtected';
    case StatusEffectType.isDevoured:
      return 'isDevoured';
    case StatusEffectType.isInfected:
      return 'isInfected';
    case StatusEffectType.isCursed:
      return 'isCursed';
    case StatusEffectType.isRevived:
      return 'isRevived';
    case StatusEffectType.isSeen:
      return 'isSeen';
    case StatusEffectType.isCountered:
      return 'isCountered';
    case StatusEffectType.isHunted:
      return 'isHunted';
    case StatusEffectType.isExecuted:
      return 'isExecuted';
    case StatusEffectType.isSubstitue:
      return 'isSubstition';
    case StatusEffectType.isServed:
      return 'isServed';
    case StatusEffectType.isServing:
      return 'isServing';
    case StatusEffectType.isJudged:
      return 'isJudged';
    case StatusEffectType.isMuted:
      return 'isMuted';
    case StatusEffectType.wasMuted:
      return 'wasMuted';
    case StatusEffectType.wasJudged:
      return 'wasJudged';
    case StatusEffectType.hasCallsign:
      return 'hasCallsign';
    case StatusEffectType.hasInheritedCaptaincy:
      return 'hasInheritedCaptaincy';
    case StatusEffectType.shouldTalkFirst:
      return 'shouldTalkFirst';
    case StatusEffectType.shouldSayTheWord:
      return 'shouldSayTheWord';
    case StatusEffectType.hasSheep:
      return "hasSheep";
  }
}

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
  shouldTalkFirst
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

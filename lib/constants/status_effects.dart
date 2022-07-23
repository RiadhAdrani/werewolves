enum StatusEffects {
  isProtected,
  wasProtected,
  isDevoured,
  isInfected,
  isCursed,
  isRevived,
  isSeen,
  isCountered,
  isHunted,
  shouldTalkFirst
}

const List<StatusEffects> fatalStatusEffects = [
  StatusEffects.isCursed,
  StatusEffects.isDevoured,
  StatusEffects.isHunted,
  StatusEffects.isCountered
];

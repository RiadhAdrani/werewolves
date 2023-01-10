enum LKey {
  // * App --------------------------------------------------------------------
  appTitle,
  reset,
  ok,
  done,
  cancel,
  start,
  loading,
  next,
  help,
  obsolete,
  playing,
  stats,
  roles,
  options,
  guess,

  // * Home Page --------------------------------------------------------------
  home,
  newGame,

  // * Selection Page ---------------------------------------------------------
  selectTitle,
  selectPlayerCountLow,
  selectAtLeastOneWolf,
  selectWolvesCountHigherVillagers,
  selectSolosCountHigherVillagers,
  selectSolosCountHigherWolves,

  // * Distribute Page --------------------------------------------------------
  distribute,
  distributeTapToPick,
  distributeAllPicked,
  distributeUnassignableName,
  distributePickName,
  distributePlayerNamePlaceholder,
  distributeReview,

  // * Game -------------------------------------------------------------------
  gameReady,

  gameShowRoleHelp,
  gameRemainingAbilities,

  gameAbilityDialogParagraph,
  gameAbilityShouldBeUsed,
  gameAbilityOptional,
  gameAbilityUsed,
  gameAbilityGuessCurrentTry,
  gameAbilityGuessTitle,
  gameAbilityGuessText,

  gameConfirmUse,
  gameConfirmUseIssueTitle,
  gameConfirmUseIssueText,
  gameConfirmUseDoneTitle,
  gameConfirmUseDoneText,

  gameNight,
  gameNightImportantInfos,
  gameNightStart,
  gameNightControllerName,
  gameNightMandatoryAbilityNotUsed,

  gameDebug,
  gameDebugTitle,
  gameDebugAlive,
  gameDebugDead,
  gameDebugVillagers,
  gameDebugWerewolves,
  gameDebugSolos,

  gameWrite,
  gameWriteHelp,
  gameWritePlaceholder,

  gameLeave,

  gameDay,
  gameDayPlayerAs,
  gameDayGuide,
  gameDayGuideNightEvents,
  gameDayGuideDayEvents,
  gameDayGuideAlive,
  gameDayGuideDead,
  gameDayGuidePhase1,
  gameDayGuidePhase2,
  gameDayGuidePhase3,
  gameDayGuidePhase4,
  gameDayUsableAbilities,
  gameDayAbilityUseTitle,
  gameDayAbilityUseText,
  gameDayAbilityTriggeredTitle,
  gameDayAbilityTriggeredText,
  gameDayEndTitle,
  gameDayEndText,

  gameExitTitle,
  gameExitText,

  protector,
  protectorDescription,
  protectorProtect,
  protectorProtectDescription,

  wolfpack,
  wolfpackDescription,
  wolfpackDevour,
  wolfpackDevourDescription,

  werewolf,
  werewolfDescription,

  villager,
  villagerDescription,

  fatherWolf,
  fatherWolfDescription,
  fatherWolfInfect,
  fatherWolfInfectDescription,

  seer,
  seerDescription,
  seerClairvoyance,
  seerClairvoyanceDescription,

  witch,
  witchDescription,
  witchRevive,
  witchReviveDescription,
  witchCurse,
  witchCurseDescription,

  knight,
  knightDescription,
  knightCounter,
  knightCounterDescription,

  hunter,
  hunterDescription,
  hunterHunt,
  hunterHuntDescription,

  judge,
  judgeDescription,
  judgeJudgement,
  judgeJudgementDescription,

  blackWolf,
  blackWolfDescription,
  blackWolfMute,
  blackWolfMuteDescription,

  garrulousWolf,
  garrulousWolfDescription,
  garrulousWolfWord,
  garrulousWolfWordDescription,

  shepherd,
  shepherdDescription,
  shepherdSheeps,
  shepherdSheepsDescription,

  alien,
  alienDescription,
  alienGuess,
  alienGuessDescription,

  captain,
  captainDescription,
  captainTalker,
  captainTalkerDescription,
  captainExecute,
  captainExecuteDescription,
  captainInherit,
  captainInheritDescription,

  commonCallsign,
  commonCallsignDescription,

  isProtected,
  isProtectedDescription,

  isDevoured,
  isDevouredDescription,

  isInfected,
  isInfectedDescription,

  isCursed,
  isCursedDescription,

  isRevived,
  isRevivedDescription,

  isSeen,
  isSeenDescription,

  isCountered,
  isCounteredDescription,

  isHunted,
  isHuntedDescription,

  isExecuted,
  isExecutedDescription,

  isJudged,
  isJudgedDescription,

  isMuted,
  isMutedDescription,

  isGuessedByAlien,
  isGuessedByAlienDescription,

  wasMuted,
  wasMutedDescription,

  wasProtected,
  wasProtectedDescription,

  wasJudged,
  wasJudgedDescription,

  hasCallsign,
  hasCallsignDescription,

  hasInheritedCaptaincy,
  hasInheritedCaptaincyDescription,

  hasSheep,
  hasSheepDescription,

  shouldTalkFirst,
  shouldTalkFirstDescription,

  hasWord,
  hasWordDescription,

  eventDeath,
  eventClairvoyance,
  eventTalk,
  eventJudge,
  eventMute,
  eventSheepDead,
  eventSheepReturned,
}

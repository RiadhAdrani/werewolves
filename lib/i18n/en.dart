import 'package:werewolves/i18n/keys.dart';

const Map<LKey, String> en = {
  LKey.appTitle: "Werewolves",
  LKey.reset: 'Reset',
  LKey.ok: 'Ok',
  LKey.done: 'Done',
  LKey.cancel: 'Cancel',
  LKey.start: 'Start',
  LKey.loading: 'Loading...',
  LKey.next: 'Next',
  LKey.help: 'Help',
  LKey.roles: 'Roles',
  LKey.stats: 'Stats',
  LKey.obsolete: 'Obsolete',
  LKey.playing: 'Playing',
  LKey.options: 'Options',
  LKey.guess: 'guess',
  LKey.newGame: "New game",
  LKey.home: 'Home',
  LKey.selectTitle: 'Selected roles ({count})',
  LKey.selectAtLeastOneWolf: 'At least one wolf should be present.',
  LKey.selectPlayerCountLow: 'Players count is too low.',
  LKey.selectSolosCountHigherVillagers:
      'Solos count is higher than the villagers count.',
  LKey.selectSolosCountHigherWolves:
      'Solos count is higher than the wolves count.',
  LKey.selectWolvesCountHigherVillagers:
      'Wolves count is higher than the villagers count.',
  LKey.distribute: 'Distribute',
  LKey.distributeTapToPick: 'Tap to pick.',
  LKey.distributeAllPicked: 'All roles are picked!',
  LKey.distributeUnassignableName:
      'Unable to assign role to player ! Name is invalid or already exists !',
  LKey.distributePickName: 'Pick a name',
  LKey.distributePlayerNamePlaceholder: 'Player name',
  LKey.distributeReview: 'Review players list ({count})',
  LKey.gameReady: 'Everything is ready !',
  LKey.gameConfirmUse: 'Confirm ability use',
  LKey.gameConfirmUseIssueTitle: 'Cannot proceed',
  LKey.gameConfirmUseIssueText:
      'You are trying to use an ability without a single selected target while it needs at least ({count}).',
  LKey.gameConfirmUseDoneTitle: 'Confirm changes.',
  LKey.gameConfirmUseDoneText:
      'Committing these changes is irreversible, make sure you selected the correct target.',
  LKey.gameAbilityGuessCurrentTry: 'Guess : {guess}',
  LKey.gameAbilityGuessTitle: '{ability} : {role}',
  LKey.gameAbilityGuessText: '',
  LKey.gameNight: 'Night ({count})',
  LKey.gameNightImportantInfos: 'Important informations',
  LKey.gameNightControllerName: '({name})',
  LKey.gameNightMandatoryAbilityNotUsed:
      'At least one mandatory ability was not used.',
  LKey.gameNightStart: 'Start night',
  LKey.gameDebug: 'Debug',
  LKey.gameDebugTitle: 'Debug Infos',
  LKey.gameDebugAlive: 'Alive : {count}',
  LKey.gameDebugDead: 'Dead : {count}',
  LKey.gameDebugVillagers: 'Villagers : {count}',
  LKey.gameDebugWerewolves: 'Werewolves : {count}',
  LKey.gameDebugSolos: 'Solos : {count}',
  LKey.gameWrite: 'Write',
  LKey.gameWriteHelp:
      'You can write something here and show it to the player in case there is some problems.',
  LKey.gameWritePlaceholder: 'Anything...',
  LKey.gameLeave: 'Leave',
  LKey.gameRemainingAbilities: 'Remaining abilities',
  LKey.gameShowRoleHelp: 'Open help dialog',
  LKey.gameAbilityShouldBeUsed: 'This ability is mandatory and should be used.',
  LKey.gameAbilityDialogParagraph:
      'You have chosen {count}/{needed} required target(s) out of {targetCount} possible option(s).',
  LKey.gameAbilityOptional: 'Optional.',
  LKey.gameAbilityUsed: "Ability used.",
  LKey.gameExitTitle: 'Game in progress',
  LKey.gameExitText: 'Are you sure you want to quit the game?',
  LKey.gameDayUsableAbilities: 'Usable abilities',
  LKey.gameDay: 'Day ({count})',
  LKey.gameDayPlayerAs: '{name} (as {role})',
  LKey.gameDayGuide: 'Guide',
  LKey.gameDayGuideNightEvents: 'Night Players',
  LKey.gameDayGuideDayEvents: 'Day Players',
  LKey.gameDayGuideAlive: 'Alive Players',
  LKey.gameDayGuideDead: 'Dead Players',
  LKey.gameDayGuidePhase1: 'Phase 1 : Discussion',
  LKey.gameDayGuidePhase2: 'Phase 2 : Vote',
  LKey.gameDayGuidePhase3: 'Phase 3 : Defense',
  LKey.gameDayGuidePhase4: 'Phase 4 : Execution',
  LKey.gameDayAbilityUseTitle: 'Before using the ability',
  LKey.gameDayAbilityUseText: 'Make sure everyone else is asleep',
  LKey.gameDayAbilityTriggeredTitle: 'Ability triggered',
  LKey.gameDayAbilityTriggeredText:
      '{name} should use his ability, Make sure everyone else is asleep!',
  LKey.gameDayEndTitle: 'End of day',
  LKey.gameDayEndText:
      'You are about to start the night phase, are you sure you completed all the steps ?',
  LKey.protector: 'Protector',
  LKey.protectorDescription: 'TODO', // TODO description
  LKey.protectorProtect: 'Protect',
  LKey.protectorProtectDescription: 'TODO', // TODO description
  LKey.wolfpack: "Wolfpack",
  LKey.wolfpackDescription: "TODO", // TODO description
  LKey.wolfpackDevour: "Devour",
  LKey.wolfpackDevourDescription: "TODO", // TODO description
  LKey.werewolf: 'Werewolf',
  LKey.werewolfDescription: 'TODO', // TODO description
  LKey.villager: 'Villager',
  LKey.villagerDescription: 'TODO', // TODO description
  LKey.fatherWolf: ' Father of Wolves',
  LKey.fatherWolfDescription: 'TODO', // TODO description
  LKey.fatherWolfInfect: 'Infect',
  LKey.fatherWolfInfectDescription: 'TODO', // TODO description
  LKey.seer: 'Seer',
  LKey.seerDescription: 'TODO', // TODO description
  LKey.seerClairvoyance: 'Clairvoyance',
  LKey.seerClairvoyanceDescription: 'TODO', // TODO description
  LKey.witch: 'Witch',
  LKey.witchDescription: 'TODO', // TODO description
  LKey.witchRevive: 'Revive',
  LKey.witchReviveDescription: 'TODO', // TODO description
  LKey.witchCurse: 'Curse',
  LKey.witchCurseDescription: 'TODO', // TODO description
  LKey.knight: 'Knight',
  LKey.knightDescription: 'TODO', // TODO description
  LKey.knightCounter: 'Counter',
  LKey.knightCounterDescription: 'TODO', // TODO description
  LKey.hunter: 'Hunter',
  LKey.hunterDescription: 'TODO', // TODO description
  LKey.hunterHunt: 'Hunt',
  LKey.hunterHuntDescription: 'TODO', // TODO description
  LKey.judge: 'Judge',
  LKey.judgeDescription: 'TODO', // TODO description
  LKey.judgeJudgement: 'Judgement',
  LKey.judgeJudgementDescription: 'TODO', // TODO description
  LKey.blackWolf: 'Black Wolf',
  LKey.blackWolfDescription: 'TODO', // TODO description
  LKey.blackWolfMute: 'Mute',
  LKey.blackWolfMuteDescription: 'TODO', // TODO description
  LKey.garrulousWolf: 'Garrulous Wolf',
  LKey.garrulousWolfDescription: 'TODO', // TODO description
  LKey.garrulousWolfWord: 'Garrulous Word',
  LKey.garrulousWolfWordDescription: 'TODO', // TODO description
  LKey.shepherd: 'Shepherd',
  LKey.shepherdDescription: 'TODO', // TODO description
  LKey.shepherdSheeps: 'Sheeps',
  LKey.shepherdSheepsDescription: 'TODO', // TODO description
  LKey.alien: 'Alien',
  LKey.alienDescription: 'TODO', // TODO description
  LKey.alienGuess: 'Alien Guess',
  LKey.alienGuessDescription: 'TODO', // TODO description
  LKey.captain: 'Captain',
  LKey.captainDescription: 'TODO', // TODO description
  LKey.captainTalker: 'Talker',
  LKey.captainTalkerDescription: 'TODO', // TODO description
  LKey.captainExecute: 'Execute',
  LKey.captainExecuteDescription: 'TODO', // TODO description
  LKey.captainInherit: 'Inherit',
  LKey.captainInheritDescription: 'TODO', // TODO description
  LKey.commonCallsign: 'Callsign',
  LKey.commonCallsignDescription: 'TODO', // TODO description
  LKey.isProtected: 'Protected',
  LKey.isProtectedDescription: 'TODO', // TODO description
  LKey.isDevoured: 'Devoured',
  LKey.isDevouredDescription: 'TODO', // TODO description
  LKey.isInfected: 'Infected',
  LKey.isInfectedDescription: 'TODO', // TODO description
  LKey.isCursed: 'Cursed',
  LKey.isCursedDescription: 'TODO', // TODO description
  LKey.isRevived: 'Revived',
  LKey.isRevivedDescription: 'TODO', // TODO description
  LKey.isSeen: 'Seen',
  LKey.isSeenDescription: 'TODO', // TODO description
  LKey.isCountered: 'Countered',
  LKey.isCounteredDescription: 'TODO', // TODO description
  LKey.isHunted: 'Hunted',
  LKey.isHuntedDescription: 'TODO', // TODO description
  LKey.isExecuted: 'Executed',
  LKey.isExecutedDescription: 'TODO', // TODO description
  LKey.isJudged: 'Judged',
  LKey.isJudgedDescription: 'TODO', // TODO description
  LKey.isMuted: 'Muted',
  LKey.isMutedDescription: 'TODO', // TODO description
  LKey.isGuessedByAlien: 'Guessed by the Alien',
  LKey.isGuessedByAlienDescription: 'TODO', // TODO description
  LKey.wasMuted: 'Was muted',
  LKey.wasMutedDescription: 'TODO', // TODO description
  LKey.wasProtected: 'Was protected',
  LKey.wasProtectedDescription: 'TODO', // TODO description
  LKey.wasJudged: 'was judged',
  LKey.wasJudgedDescription: 'TODO', // TODO description
  LKey.hasCallsign: 'Has callsign',
  LKey.hasCallsignDescription: 'TODO', // TODO description
  LKey.hasInheritedCaptaincy: 'Has inherited captaincy',
  LKey.hasInheritedCaptaincyDescription: 'TODO', // TODO description
  LKey.hasSheep: 'Has a sheep',
  LKey.hasSheepDescription: 'TODO', // TODO description
  LKey.shouldTalkFirst: 'Should talk first',
  LKey.shouldTalkFirstDescription: 'TODO', // TODO description
  LKey.hasWord: 'Has word',
  LKey.hasWordDescription: 'TODO', // TODO description
  LKey.eventDeath: '{name} died.',
  LKey.eventTalk: '{name} starts the discussion.',
  LKey.eventClairvoyance: 'The seer saw : {role}',
  LKey.eventJudge: 'The judge protected {name}.',
  LKey.eventMute: '{name} is muted.',
  LKey.eventSheepDead: 'A sheep was killed',
  LKey.eventSheepReturned: 'A sheep returned to the shepherd',
};

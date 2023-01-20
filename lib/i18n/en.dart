import 'package:werewolves/i18n/keys.dart';

const Map<LK, String> en = {
  LK.appTitle: "Werewolves",
  LK.reset: 'Reset',
  LK.ok: 'Ok',
  LK.done: 'Done',
  LK.cancel: 'Cancel',
  LK.start: 'Start',
  LK.loading: 'Loading...',
  LK.next: 'Next',
  LK.help: 'Help',
  LK.roles: 'Roles',
  LK.stats: 'Stats',
  LK.obsolete: 'Obsolete',
  LK.playing: 'Playing',
  LK.options: 'Options',
  LK.guess: 'guess',
  LK.newGame: "New game",
  LK.home: 'Home',
  LK.selectTitle: 'Selected roles ({count})',
  LK.selectAtLeastOneWolf: 'At least one wolf should be present.',
  LK.selectPlayerCountLow: 'Players count is too low.',
  LK.selectSolosCountHigherVillagers:
      'Solos count is higher than the villagers count.',
  LK.selectSolosCountHigherWolves:
      'Solos count is higher than the wolves count.',
  LK.selectWolvesCountHigherVillagers:
      'Wolves count is higher than the villagers count.',
  LK.distribute: 'Distribute',
  LK.distributeTapToPick: 'Tap to pick.',
  LK.distributeAllPicked: 'All roles are picked!',
  LK.distributeUnassignableName:
      'Unable to assign role to player ! Name is invalid or already exists !',
  LK.distributePickName: 'Pick a name',
  LK.distributePlayerNamePlaceholder: 'Player name',
  LK.distributeReview: 'Review players list ({count})',
  LK.gameReady: 'Everything is ready !',
  LK.gameConfirmUse: 'Confirm ability use',
  LK.gameConfirmUseIssueTitle: 'Cannot proceed',
  LK.gameConfirmUseIssueText:
      'You are trying to use an ability without a single selected target while it needs at least ({count}).',
  LK.gameConfirmUseDoneTitle: 'Confirm changes.',
  LK.gameConfirmUseDoneText:
      'Committing these changes is irreversible, make sure you selected the correct target.',
  LK.gameAbilityGuessCurrentTry: 'Guess : {guess}',
  LK.gameAbilityGuessTitle: '{ability} : {role}',
  LK.gameAbilityGuessText: '',
  LK.gameNight: 'Night ({count})',
  LK.gameNightImportantInfos: 'Important informations',
  LK.gameNightControllerName: '({name})',
  LK.gameNightMandatoryAbilityNotUsed:
      'At least one mandatory ability was not used.',
  LK.gameNightStart: 'Start night',
  LK.gameDebug: 'Debug',
  LK.gameDebugTitle: 'Debug Infos',
  LK.gameDebugAlive: 'Alive : {count}',
  LK.gameDebugDead: 'Dead : {count}',
  LK.gameDebugVillagers: 'Villagers : {count}',
  LK.gameDebugWerewolves: 'Werewolves : {count}',
  LK.gameDebugSolos: 'Solos : {count}',
  LK.gameWrite: 'Write',
  LK.gameWriteHelp:
      'You can write something here and show it to the player in case there is some problems.',
  LK.gameWritePlaceholder: 'Anything...',
  LK.gameLeave: 'Leave',
  LK.gameRemainingAbilities: 'Remaining abilities',
  LK.gameShowRoleHelp: 'Open help dialog',
  LK.gameAbilityShouldBeUsed: 'This ability is mandatory and should be used.',
  LK.gameAbilityDialogParagraph:
      'You have chosen {count}/{needed} required target(s) out of {targetCount} possible option(s).',
  LK.gameAbilityOptional: 'Optional.',
  LK.gameAbilityUsed: "Ability used.",
  LK.gameExitTitle: 'Game in progress',
  LK.gameExitText: 'Are you sure you want to quit the game?',
  LK.gameDayUsableAbilities: 'Usable abilities',
  LK.gameDay: 'Day ({count})',
  LK.gameDayPlayerAs: '{name} (as {role})',
  LK.gameDayGuide: 'Guide',
  LK.gameDayGuideNightEvents: 'Night events',
  LK.gameDayGuideDayEvents: 'Day events',
  LK.gameDayGuideAlive: 'Alive players',
  LK.gameDayGuideDead: 'Dead players',
  LK.gameDayGuidePhase1: 'Phase 1 : Discussion',
  LK.gameDayGuidePhase2: 'Phase 2 : Vote',
  LK.gameDayGuidePhase3: 'Phase 3 : Defense',
  LK.gameDayGuidePhase4: 'Phase 4 : Execution',
  LK.gameDayAbilityUseTitle: 'Before using the ability',
  LK.gameDayAbilityUseText: 'Make sure everyone else is asleep',
  LK.gameDayAbilityTriggeredTitle: 'Ability triggered',
  LK.gameDayAbilityTriggeredText:
      '{name} should use his ability, Make sure everyone else is asleep!',
  LK.gameDayEndTitle: 'End of day',
  LK.gameDayEndText:
      'You are about to start the night phase, are you sure you completed all the steps ?',
  LK.protector: 'Protector',
  LK.protectorDescription: 'TODO', // TODO description
  LK.protectorProtect: 'Protect',
  LK.protectorProtectDescription: 'TODO', // TODO description
  LK.wolfpack: "Wolfpack",
  LK.wolfpackDescription: "TODO", // TODO description
  LK.wolfpackDevour: "Devour",
  LK.wolfpackDevourDescription: "TODO", // TODO description
  LK.werewolf: 'Werewolf',
  LK.werewolfDescription: 'TODO', // TODO description
  LK.villager: 'Villager',
  LK.villagerDescription: 'TODO', // TODO description
  LK.fatherWolf: ' Father of Wolves',
  LK.fatherWolfDescription: 'TODO', // TODO description
  LK.fatherWolfInfect: 'Infect',
  LK.fatherWolfInfectDescription: 'TODO', // TODO description
  LK.seer: 'Seer',
  LK.seerDescription: 'TODO', // TODO description
  LK.seerClairvoyance: 'Clairvoyance',
  LK.seerClairvoyanceDescription: 'TODO', // TODO description
  LK.witch: 'Witch',
  LK.witchDescription: 'TODO', // TODO description
  LK.witchRevive: 'Revive',
  LK.witchReviveDescription: 'TODO', // TODO description
  LK.witchCurse: 'Curse',
  LK.witchCurseDescription: 'TODO', // TODO description
  LK.knight: 'Knight',
  LK.knightDescription: 'TODO', // TODO description
  LK.knightCounter: 'Counter',
  LK.knightCounterDescription: 'TODO', // TODO description
  LK.hunter: 'Hunter',
  LK.hunterDescription: 'TODO', // TODO description
  LK.hunterHunt: 'Hunt',
  LK.hunterHuntDescription: 'TODO', // TODO description
  LK.judge: 'Judge',
  LK.judgeDescription: 'TODO', // TODO description
  LK.judgeJudgement: 'Judgement',
  LK.judgeJudgementDescription: 'TODO', // TODO description
  LK.blackWolf: 'Black Wolf',
  LK.blackWolfDescription: 'TODO', // TODO description
  LK.blackWolfMute: 'Mute',
  LK.blackWolfMuteDescription: 'TODO', // TODO description
  LK.garrulousWolf: 'Garrulous Wolf',
  LK.garrulousWolfDescription: 'TODO', // TODO description
  LK.garrulousWolfWord: 'Garrulous Word',
  LK.garrulousWolfWordDescription: 'TODO', // TODO description
  LK.shepherd: 'Shepherd',
  LK.shepherdDescription: 'TODO', // TODO description
  LK.shepherdSheeps: 'Sheeps',
  LK.shepherdSheepsDescription: 'TODO', // TODO description
  LK.alien: 'Alien',
  LK.alienDescription: 'TODO', // TODO description
  LK.alienGuess: 'Alien Guess',
  LK.alienGuessDescription: 'TODO', // TODO description
  LK.captain: 'Captain',
  LK.captainDescription: 'TODO', // TODO description
  LK.captainTalker: 'Talker',
  LK.captainTalkerDescription: 'TODO', // TODO description
  LK.captainExecute: 'Execute',
  LK.captainExecuteDescription: 'TODO', // TODO description
  LK.captainInherit: 'Inherit',
  LK.captainInheritDescription: 'TODO', // TODO description
  LK.commonCallsign: 'Callsign',
  LK.commonCallsignDescription: 'TODO', // TODO description
  LK.isProtected: 'Protected',
  LK.isProtectedDescription: 'TODO', // TODO description
  LK.isDevoured: 'Devoured',
  LK.isDevouredDescription: 'TODO', // TODO description
  LK.isInfected: 'Infected',
  LK.isInfectedDescription: 'TODO', // TODO description
  LK.isCursed: 'Cursed',
  LK.isCursedDescription: 'TODO', // TODO description
  LK.isRevived: 'Revived',
  LK.isRevivedDescription: 'TODO', // TODO description
  LK.isSeen: 'Seen',
  LK.isSeenDescription: 'TODO', // TODO description
  LK.isCountered: 'Countered',
  LK.isCounteredDescription: 'TODO', // TODO description
  LK.isHunted: 'Hunted',
  LK.isHuntedDescription: 'TODO', // TODO description
  LK.isExecuted: 'Executed',
  LK.isExecutedDescription: 'TODO', // TODO description
  LK.isJudged: 'Judged',
  LK.isJudgedDescription: 'TODO', // TODO description
  LK.isMuted: 'Muted',
  LK.isMutedDescription: 'TODO', // TODO description
  LK.isGuessedByAlien: 'Guessed by the Alien',
  LK.isGuessedByAlienDescription: 'TODO', // TODO description
  LK.wasMuted: 'Was muted',
  LK.wasMutedDescription: 'TODO', // TODO description
  LK.wasProtected: 'Was protected',
  LK.wasProtectedDescription: 'TODO', // TODO description
  LK.wasJudged: 'was judged',
  LK.wasJudgedDescription: 'TODO', // TODO description
  LK.hasCallsign: 'Has callsign',
  LK.hasCallsignDescription: 'TODO', // TODO description
  LK.hasInheritedCaptaincy: 'Has inherited captaincy',
  LK.hasInheritedCaptaincyDescription: 'TODO', // TODO description
  LK.hasSheep: 'Has a sheep',
  LK.hasSheepDescription: 'TODO', // TODO description
  LK.shouldTalkFirst: 'Should talk first',
  LK.shouldTalkFirstDescription: 'TODO', // TODO description
  LK.hasWord: 'Has word',
  LK.hasWordDescription: 'TODO', // TODO description
  LK.eventDeath: '{name} died.',
  LK.eventTalk: '{name} starts the discussion.',
  LK.eventClairvoyance: 'The seer saw : {role}',
  LK.eventJudge: 'The judge protected {name}.',
  LK.eventMute: '{name} is muted.',
  LK.eventSheepDead: 'A sheep was killed',
  LK.eventSheepReturned: 'A sheep returned to the shepherd',
};

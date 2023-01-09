import 'package:werewolves/i18n/keys.dart';

const Map<LKey, String> en = {
  // * App --------------------------------------------------------------------
  LKey.appTitle: "Werewolves",
  LKey.reset: 'Reset',
  LKey.ok: 'Ok',
  LKey.done: 'Done',
  LKey.cancel: 'Cancel',

  // * Home Page --------------------------------------------------------------
  LKey.newGame: "New game",
  LKey.home: 'Home',

  // * Selection Page ---------------------------------------------------------
  LKey.selectTitle: 'Selected roles ({count})',
  LKey.selectAtLeastOneWolf: 'At least one wolf should be present.',
  LKey.selectPlayerCountLow: 'Players count is too low.',
  LKey.selectSolosCountHigherVillagers:
      'Solos count is higher than the villagers count.',
  LKey.selectSolosCountHigherWolves:
      'Solos count is higher than the wolves count.',
  LKey.selectWolvesCountHigherVillagers:
      'Wolves count is higher than the villagers count.',

  // * Distribute Page --------------------------------------------------------
  LKey.distribute: 'Distribute',
  LKey.distributeTapToPick: 'Tap to pick.',
  LKey.distributeAllPicked: 'All roles are picked!',
  LKey.distributeUnassignableName:
      'Unable to assign role to player ! Name is invalid or already exists !',
  LKey.distributePickName: 'Pick a name',
  LKey.distributePlayerNamePlaceholder: 'Player name',
};

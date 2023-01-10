import 'package:werewolves/i18n/keys.dart';

const Map<LKey, String> fr = {
  // * App --------------------------------------------------------------------
  LKey.appTitle: "Les Loups garous",
  LKey.reset: 'Réinitialiser',
  LKey.ok: 'Ok',
  LKey.done: 'Fini',
  LKey.cancel: 'Annuler',

  // * Home Page --------------------------------------------------------------
  LKey.newGame: "Nouvelle jeu",
  LKey.home: 'Accueil',

  // * Selection Page ---------------------------------------------------------
  LKey.selectTitle: 'Rôles sélectionnés ({count})',
  LKey.selectAtLeastOneWolf: 'Au moins un loup doit être présent.',
  LKey.selectPlayerCountLow: 'Le nombre de joueurs est trop faible.',
  LKey.selectSolosCountHigherVillagers:
      'Le nombre de solos est supérieur au nombre de villageois.',
  LKey.selectSolosCountHigherWolves:
      'Le nombre de solos est supérieur au nombre de loups.',
  LKey.selectWolvesCountHigherVillagers:
      'Le nombre de loups est supérieur au nombre de villageois.',

  // * Distribute Page --------------------------------------------------------
  LKey.distribute: 'Distribuer',
  LKey.distributeTapToPick: 'Appuyez pour choisir.',
  LKey.distributeAllPicked: 'Tous les rôles sont choisis !',
  LKey.distributeUnassignableName:
      'Impossible d\'attribuer un rôle au joueur ! Le nom est invalide ou existe déjà !',
  LKey.distributePickName: 'choisissez un nom',
  LKey.distributePlayerNamePlaceholder: 'Nom de joueur',
};

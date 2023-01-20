import 'package:werewolves/i18n/keys.dart';

const Map<LK, String> fr = {
  // * App --------------------------------------------------------------------
  LK.appTitle: "Les Loups garous",
  LK.reset: 'Réinitialiser',
  LK.ok: 'Ok',
  LK.done: 'Fini',
  LK.cancel: 'Annuler',

  // * Home Page --------------------------------------------------------------
  LK.newGame: "Nouvelle jeu",
  LK.home: 'Accueil',

  // * Selection Page ---------------------------------------------------------
  LK.selectTitle: 'Rôles sélectionnés ({count})',
  LK.selectAtLeastOneWolf: 'Au moins un loup doit être présent.',
  LK.selectPlayerCountLow: 'Le nombre de joueurs est trop faible.',
  LK.selectSolosCountHigherVillagers:
      'Le nombre de solos est supérieur au nombre de villageois.',
  LK.selectSolosCountHigherWolves:
      'Le nombre de solos est supérieur au nombre de loups.',
  LK.selectWolvesCountHigherVillagers:
      'Le nombre de loups est supérieur au nombre de villageois.',

  // * Distribute Page --------------------------------------------------------
  LK.distribute: 'Distribuer',
  LK.distributeTapToPick: 'Appuyez pour choisir.',
  LK.distributeAllPicked: 'Tous les rôles sont choisis !',
  LK.distributeUnassignableName:
      'Impossible d\'attribuer un rôle au joueur ! Le nom est invalide ou existe déjà !',
  LK.distributePickName: 'choisissez un nom',
  LK.distributePlayerNamePlaceholder: 'Nom de joueur',
};

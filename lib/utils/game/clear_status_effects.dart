import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/utils/game/resolve_seen_role.dart';

void resolveEffectsAndCollectInfosOfNight(GameModel game) {
  int currentTurn = game.getCurrentTurn();

  game.getPlayersList().forEach((player) {
    final newEffects = <Effect>[];

    for (var effect in player.effects) {
      /// do not remove permanent or fatal effects.
      /// Fatal effects will be treated later
      /// by confirming the death of the players
      /// and moving them into the graveyard.
      if (effect.permanent || isFatalEffect(effect.type)) {
        continue;
      }

      switch (effect.type) {

        /// Protector -----------------------------------------------------
        case EffectId.isProtected:

          /// currently protected player could not be protected again
          /// add [wasProtected] effect
          /// so he won't be targeted by the protector in the next turn.
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasProtectedEffect(effect.source));
          break;

        /// Black Wolf ----------------------------------------------------
        case EffectId.isMuted:

          /// Currently muted player cannot be muted two night in a row
          /// so we add [wasMuted] effect.
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasMutedEffect(effect.source));

          if (!(effect.source.player as Player).hasFatalEffect()) {
            game.addGameInfo(
                GameInformation.mutedInformation(player, currentTurn));
          }

          break;

        /// Seer ----------------------------------------------------------
        case EffectId.isSeen:
          player.removeEffectsOfType(effect.type);

          /// If the seer is dead, we do not report anything
          if ((effect.source as RoleSingular).player.hasFatalEffect()) {
            break;
          }

          Role role = resolveSeenRole(player);

          game.addGameInfo(GameInformation.clairvoyanceInformation(
              role.id, game.getState(), currentTurn));

          break;

        /// Judge --------------------------------------------------------
        /// Role cannot be protected by the judge two consecutive rounds.
        case EffectId.isJudged:
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasJudgedEffect(effect.source));

          game.addGameInfo(
              GameInformation.judgeInformation(player, currentTurn));
          break;

        /// Captain ------------------------------------------------------
        case EffectId.shouldTalkFirst:
          game.addGameInfo(GameInformation.talkInformation(
              player, game.getState(), currentTurn));

          player.removeEffectsOfType(effect.type);
          break;

        /// Shepherd -----------------------------------------------------
        case EffectId.hasSheep:

          /// If the player has a wolf role
          /// We should remove one sheep
          /// which in our case is the target count.
          if (player.hasWolfRole()) {
            Ability shepherdAbility =
                effect.source.getAbilityOfType(AbilityId.sheeps)!;

            shepherdAbility.targetCount--;
            game.addGameInfo(
                GameInformation.sheepInformation(true, currentTurn));
          } else {
            game.addGameInfo(
                GameInformation.sheepInformation(false, currentTurn));
          }

          player.removeEffectsOfType(effect.type);
          break;

        /// Common effects -----------------------------------------------
        /// Should only be removed.
        case EffectId.isRevived:
        case EffectId.isSubstitue:
        case EffectId.hasInheritedCaptaincy:
        case EffectId.wasProtected:
        case EffectId.wasJudged:
        case EffectId.wasMuted:
        case EffectId.shouldSayTheWord:
          player.removeEffectsOfType(effect.type);
          break;

        /// Unreachable code because these effects are permanent. --------
        /// Fatal or permanent effects.
        case EffectId.isCountered:
        case EffectId.isExecuted:
        case EffectId.isDevoured:
        case EffectId.isHunted:
        case EffectId.isCursed:
        case EffectId.hasCallsign:
        case EffectId.isInfected:
        case EffectId.isServed:
        case EffectId.isServing:
        case EffectId.isGuessed:
          break;
      }
    }

    /// Apply new effects
    for (var effect in newEffects) {
      player.addStatusEffect(effect);
    }
  });
}

void resolveEffectsAndCollectInfosOfDay(GameModel game) {
  int currentTurn = game.getCurrentTurn();

  game.getPlayersList().forEach((player) {
    if (player.hasFatalEffect()) {
      game.addGameInfo(
          GameInformation.deathInformation(player, GameState.day, currentTurn));
    }
  });
}

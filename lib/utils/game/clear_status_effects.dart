import 'package:werewolves/constants/ability_id.dart';
import 'package:werewolves/constants/game_states.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game_info.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/effects/was_judged_effect.dart';
import 'package:werewolves/objects/effects/was_muted_effect.dart';
import 'package:werewolves/objects/effects/was_protected_effect.dart';
import 'package:werewolves/utils/game/resolve_seen_role.dart';

void resolveEffectsAndCollectInfosOfNight(GameModel game) {
  int currentTurn = game.getCurrentTurn();

  game.getPlayersList().forEach((player) {
    final newEffects = <StatusEffect>[];

    for (var effect in player.effects) {
      /// do not remove premanent or fatal effects.
      /// Fatal effects will be treated later
      /// by confirming the death of the players
      /// and moving them into the graveyard.
      if (effect.permanent || isFatalEffect(effect.type)) {
        continue;
      }

      switch (effect.type) {

        /// Protector -----------------------------------------------------
        case StatusEffectType.isProtected:

          /// currently protected player could not be protected again
          /// add [wasProtected] effect
          /// so he won't be targeted by the protector in the next turn.
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasProtectedStatusEffect(effect.source));
          break;

        /// Black Wolf ----------------------------------------------------
        case StatusEffectType.isMuted:

          /// Currently muted player cannot be muted two night in a row
          /// so we add [wasMuted] effect.
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasMutedStatusEffect(effect.source));

          if (!(effect.source.player as Player).hasFatalEffect()) {
            game.addGameInfo(GameInformation.mutedInformation(player, currentTurn));
          }

          break;

        /// Seer ----------------------------------------------------------
        case StatusEffectType.isSeen:
          player.removeEffectsOfType(effect.type);

          /// If the seer is dead, we do not report anything
          if ((effect.source as RoleSingular).player.hasFatalEffect()) {
            break;
          }

          Role role = resolveSeenRole(player);

          game.addGameInfo(
              GameInformation.clairvoyanceInformation(role.id, game.getState(), currentTurn));

          break;

        /// Judge --------------------------------------------------------
        /// Role cannot be protected by the judge two consecutive rounds.
        case StatusEffectType.isJudged:
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasJudgedStatusEffect(effect.source));

          game.addGameInfo(GameInformation.judgeInformation(player, currentTurn));
          break;

        /// Captain ------------------------------------------------------
        case StatusEffectType.shouldTalkFirst:
          game.addGameInfo(GameInformation.talkInformation(player, game.getState(), currentTurn));

          player.removeEffectsOfType(effect.type);
          break;

        /// Shepherd -----------------------------------------------------
        case StatusEffectType.hasSheep:

          /// If the playe has a wolf role
          /// We should remove one sheep
          /// which in our case is the target count.
          if (player.hasWolfRole()) {
            Ability shepherdAbility = effect.source.getAbilityOfType(AbilityId.sheeps)!;

            shepherdAbility.targetCount--;
            game.addGameInfo(GameInformation.sheepInformation(true, currentTurn));
          } else {
            game.addGameInfo(GameInformation.sheepInformation(false, currentTurn));
          }

          player.removeEffectsOfType(effect.type);
          break;

        /// Common effects -----------------------------------------------
        /// Should only be removed.
        case StatusEffectType.isRevived:
        case StatusEffectType.isSubstitue:
        case StatusEffectType.hasInheritedCaptaincy:
        case StatusEffectType.wasProtected:
        case StatusEffectType.wasJudged:
        case StatusEffectType.wasMuted:
        case StatusEffectType.shouldSayTheWord:
          player.removeEffectsOfType(effect.type);
          break;

        /// Unreachable code because these effects are premanent. --------
        /// Fatal or permanent effects.
        case StatusEffectType.isCountered:
        case StatusEffectType.isExecuted:
        case StatusEffectType.isDevoured:
        case StatusEffectType.isHunted:
        case StatusEffectType.isCursed:
        case StatusEffectType.hasCallsign:
        case StatusEffectType.isInfected:
        case StatusEffectType.isServed:
        case StatusEffectType.isServing:
        case StatusEffectType.isGuessed:
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
      game.addGameInfo(GameInformation.deathInformation(player, GameState.day, currentTurn));
    }
  });
}

import 'package:werewolves/constants/game_states.dart';
import 'package:werewolves/constants/status_effects.dart';
import 'package:werewolves/models/game_info.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/role_single.dart';
import 'package:werewolves/models/status_effect.dart';
import 'package:werewolves/objects/effects/was_judged_effect.dart';
import 'package:werewolves/objects/effects/was_protected_effect.dart';
import 'package:werewolves/utils/game/resolve_seen_role.dart';

void resolveEffectsAndCollectInfosOfNight(GameModel game) {
  game.getPlayersList().forEach((player) {
    final newEffects = <StatusEffect>[];

    // if (player.hasFatalEffect() &&
    //     player.hasEffect(StatusEffectType.isServed)) {
    //   if (player.hasEffect(StatusEffectType.isServed)) {
    //     var mainRole = player.getMainRole();

    //     game.onServedDeath(mainRole, () {});
    //   }
    // }

    for (var effect in player.effects) {
      /// do not remove premanent or fatal effects.
      /// Fatal effects will be treated later
      /// by confirming the death of the players
      /// and moving them into the graveyard.
      if (effect.permanent || isFatalEffect(effect.type)) {
        continue;
      }

      switch (effect.type) {

        /// Protector shield
        /// currently protected player could not be protected again
        /// add [wasProtected] effect
        /// so he won't be targeted by the protector in the next turn.
        case StatusEffectType.isProtected:
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasProtectedStatusEffect(effect.source));
          break;

        /// Add seen role and add a game info.
        case StatusEffectType.isSeen:
          player.removeEffectsOfType(effect.type);

          /// If the seer is dead, we do not report anything
          if ((effect.source as RoleSingular).player.hasFatalEffect()) {
            break;
          }

          Role role = resolveSeenRole(player);

          game.addGameInfo(GameInformation.clairvoyanceInformation(
              role.id, game.getState(), game.getCurrentTurn()));

          break;

        /// Judge protection
        /// Role cannot be protected by the judge two consecutive rounds.
        case StatusEffectType.isJudged:
          player.removeEffectsOfType(effect.type);
          newEffects.add(WasJudgedStatusEffect(effect.source));

          game.addGameInfo(
              GameInformation.judgeInformation(player, game.getCurrentTurn()));
          break;

        /// Captain order
        case StatusEffectType.shouldTalkFirst:
          game.addGameInfo(GameInformation.talkInformation(
              player, game.getState(), game.getCurrentTurn()));

          player.removeEffectsOfType(effect.type);
          break;

        /// Common effects.
        /// Should only be removed.
        case StatusEffectType.wasProtected:
        case StatusEffectType.isDevoured:
        case StatusEffectType.isCursed:
        case StatusEffectType.isRevived:
        case StatusEffectType.isCountered:
        case StatusEffectType.isHunted:
        case StatusEffectType.isExecuted:
        case StatusEffectType.isSubstitue:
        case StatusEffectType.hasInheritedCaptaincy:
        case StatusEffectType.wasJudged:
          player.removeEffectsOfType(effect.type);
          break;

        /// Unreachable code because these effects are premanent.
        case StatusEffectType.hasCallsign:
        case StatusEffectType.isInfected:
        case StatusEffectType.isServed:
        case StatusEffectType.isServing:
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
  game.getPlayersList().forEach((player) {
    if (player.hasFatalEffect()) {
      game.addGameInfo(GameInformation.deathInformation(
          player, GameState.day, game.getCurrentTurn()));
    }
  });
}

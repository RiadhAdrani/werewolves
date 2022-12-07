import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/alien.dart';

import 'utils.dart';

void main() {
  group('Alien', () {
    group('Role', () {
      var role = Alien(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.alien);
      });

      test('should be a group', () {
        expect(role.isGroup, false);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, alienPriority);
      });

      test('should have a call sign ability', () {
        expect(role.hasAbilityOfType(AbilityId.callsign), true);
      });

      test('should have a hunt ability', () {
        expect(role.hasAbilityOfType(AbilityId.guess), true);
      });

      test('should be called at night when without sign', () {
        var role = createRole(id: RoleId.alien);

        expect(role.shouldBeCalledAtNight([], 2), true);
      });

      test('should NOT be called at night when with sign', () {
        var role = Alien(createPlayer(effects: [EffectId.hasCallsign]));

        expect(role.shouldBeCalledAtNight([], 20), false);
      });

      test('should be able to use ability at night', () {
        expect(role.canUseAbilitiesDuringNight(), true);
      });

      test('should be able to use ability at day', () {
        expect(role.canUseAbilitiesDuringDay(), true);
      });

      test('should be able to use sign with narrator', () {
        expect(role.canUseSignWithNarrator(), true);
      });

      test('should return the correct initial team', () {
        expect(role.getSupposedInitialTeam(), Team.alien);
      });

      test('should return the correct alien guess', () {
        expect(
          Alien.resolveAlienGuessPossibility(RoleId.villager),
          RoleId.villager,
        );
        expect(
          Alien.resolveAlienGuessPossibility(RoleId.knight),
          RoleId.knight,
        );
        expect(
          Alien.resolveAlienGuessPossibility(RoleId.alien),
          RoleId.alien,
        );
        expect(
          Alien.resolveAlienGuessPossibility(RoleId.werewolf),
          RoleId.werewolf,
        );
        expect(
          Alien.resolveAlienGuessPossibility(RoleId.fatherOfWolves),
          RoleId.werewolf,
        );
        expect(
          Alien.resolveAlienGuessPossibility(RoleId.blackWolf),
          RoleId.werewolf,
        );
        expect(
          Alien.resolveAlienGuessPossibility(RoleId.garrulousWolf),
          RoleId.werewolf,
        );
      });

      test('should resolve alien guess correctly', () {
        expect(
          Alien.resolveAlienGuess(
            createPlayer(
              roles: [RoleId.hunter],
            ),
            RoleId.hunter,
          ),
          true,
        );
        expect(
          Alien.resolveAlienGuess(
            createPlayer(
              roles: [RoleId.captain, RoleId.wolfpack, RoleId.hunter],
            ),
            RoleId.hunter,
          ),
          true,
        );
      });

      test('should resolve all roles if guessed correctly', () {
        var player1 = createPlayer(roles: [RoleId.villager]);
        var player2 = createPlayer(roles: [RoleId.captain]);
        var player3 = createPlayer(roles: [RoleId.werewolf]);
        var player4 = createPlayer(roles: [RoleId.protector]);
        var player5 = createPlayer(roles: [RoleId.witch]);

        AlienGuessItem createItem(Player player,
            {bool selected = true, required RoleId guess}) {
          var item = AlienGuessItem(player);

          item.guess = guess;
          item.selected = selected;

          return item;
        }

        expect(
          Alien.getCorrectlyGuessedRoles([
            createItem(player1, guess: RoleId.villager),
          ]),
          [player1],
        );

        expect(
          Alien.getCorrectlyGuessedRoles([
            createItem(player1, guess: RoleId.villager, selected: true),
            createItem(player2, guess: RoleId.captain, selected: false),
            createItem(player3, guess: RoleId.werewolf, selected: false),
            createItem(player4, guess: RoleId.protector, selected: false),
            createItem(player5, guess: RoleId.witch, selected: false),
          ]),
          [player1],
        );

        expect(
          Alien.getCorrectlyGuessedRoles([
            createItem(player1, guess: RoleId.villager, selected: true),
            createItem(player2, guess: RoleId.villager, selected: true),
            createItem(player3, guess: RoleId.werewolf, selected: false),
            createItem(player4, guess: RoleId.protector, selected: false),
            createItem(player5, guess: RoleId.witch, selected: false),
          ]),
          false,
        );

        expect(
          Alien.getCorrectlyGuessedRoles([
            createItem(player1, guess: RoleId.villager),
            createItem(player2, guess: RoleId.captain),
            createItem(player3, guess: RoleId.werewolf),
            createItem(player4, guess: RoleId.protector),
            createItem(player5, guess: RoleId.witch),
          ]),
          [player1, player2, player3, player4, player5],
        );
      });
    });

    group('Effects', () {
      test('isGuessedByAlien effect should have correct property values', () {
        Effect effect = GuessedByAlienEffect(Alien(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isGuessedByAlien);
      });
    });

    group('Abilities', () {
      group('Guess', () {
        Ability ability = GuessAbility(Alien(Player('test')));

        test('should have correct properties values', () {
          expect(ability.targetCount, infinite);
          expect(ability.id, AbilityId.guess);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.infinite);
          expect(ability.time, AbilityTime.day);
        });

        test('should add effect', () {
          var player = createPlayer();

          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.isGuessedByAlien), true);
        });

        test('should be able to target other players', () {
          expect(ability.isTarget(createPlayer()), true);
        });

        test('should NOT be able to target self', () {
          var player = createPlayer();
          var ability = createAbilityFromId(AbilityId.guess, Alien(player));

          expect(ability.isTarget(player), false);
        });

        test('should be applied surely at any case', () {
          expect(ability.shouldBeAppliedSurely(createPlayer()), true);
        });

        test('should be available', () {
          expect(ability.shouldBeAvailable(), true);
        });

        test('should be unskippable', () {
          expect(ability.isUnskippable(), false);
        });

        test('should be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), false);
        });
      });
    });
  });
}

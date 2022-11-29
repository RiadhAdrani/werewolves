import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/witch.dart';

import 'utils.dart';

void main() {
  group('Witch', () {
    group('Role', () {
      var role = Witch(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.witch);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, witchPriority);
      });

      test('should have a curse ability', () {
        expect(role.hasAbilityOfType(AbilityId.curse), true);
      });

      test('should have a revive ability', () {
        expect(role.hasAbilityOfType(AbilityId.revive), true);
      });

      test('should be called at night', () {
        expect(role.shouldBeCalledAtNight([], 1), true);
      });

      test('should be able to use ability at night', () {
        expect(role.canUseAbilitiesDuringNight(), true);
      });

      test('should NOT be able to use ability at day', () {
        expect(role.canUseAbilitiesDuringDay(), false);
      });

      test('should NOT be able to use sign with narrator', () {
        expect(role.canUseSignWithNarrator(), false);
      });

      test('should return the correct initial team', () {
        expect(role.getSupposedInitialTeam(), Team.village);
      });
    });

    group('Effects', () {
      test('isCursed effect should have correct property values', () {
        Effect effect = CursedEffect(Witch(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isCursed);
      });

      test('isRevived effect should have correct property values', () {
        Effect effect = RevivedEffect(Witch(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isRevived);
      });
    });

    group('Abilities', () {
      group('Curse', () {
        Ability ability = CurseAbility(Witch(Player('test')));

        test('CurseAbility should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.curse);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.once);
          expect(ability.time, AbilityTime.night);
        });

        test('should add curse effect to target', () {
          var player = Player('test');

          ability.callOnTarget(player);
          expect(player.hasEffect(EffectId.isCursed), true);
        });

        test('should be able to target any player', () {
          expect(ability.isTarget(createPlayer()), true);
        });

        test('should be applied surely at any case', () {
          var player = Player('test');

          expect(ability.shouldBeAppliedSurely(player), true);
        });

        test('should be available at any case', () {
          expect(ability.shouldBeAvailable(), true);
        });

        test('should be unskippable', () {
          expect(ability.isUnskippable(), false);
        });

        test('should NOT be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), false);
        });
      });
      group('Revive', () {
        Ability ability = ReviveAbility(Witch(Player('test')));

        test('ReviveAbility should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.revive);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.once);
          expect(ability.time, AbilityTime.night);
        });

        test('should add revive effect to target', () {
          var player = createPlayer(effects: fatalStatusEffects);

          ability.callOnTarget(player);
          expect(player.hasEffect(EffectId.isRevived), true);
          expect(player.hasFatalEffect, false);
        });

        test('should only target fatally affected players', () {
          for (var effect in fatalStatusEffects) {
            expect(ability.isTarget(createPlayer(effects: [effect])), true);
          }
        });

        test('should Not be able to target non-fatally affected players', () {
          expect(ability.isTarget(createPlayer()), false);
        });

        test('should be applied surely at any case', () {
          var player = Player('test');

          expect(ability.shouldBeAppliedSurely(player), true);
        });

        test('should be available at any case', () {
          expect(ability.shouldBeAvailable(), true);
        });

        test('should be unskippable', () {
          expect(ability.isUnskippable(), false);
        });

        test('should NOT be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), false);
        });
      });
    });
  });
}

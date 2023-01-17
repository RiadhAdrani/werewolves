import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/garrulous_wolf.dart';

import 'utils.dart';

void main() {
  group('Garrulous Wolf', () {
    group('Role', () {
      var self = createPlayer();
      var role = GarrulousWolf(self);

      test('should have an id', () {
        expect(role.id, RoleId.garrulousWolf);
      });

      test('should be a wolf', () {
        expect(role.isWolf, true);
      });

      test('should be a group', () {
        expect(role.isGroup, false);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, garrulousWolfPriority);
      });

      test('should have a word ability', () {
        expect(role.hasAbilityOfType(AbilityId.word), true);
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

      test('should set word', () {
        var role = GarrulousWolf(createPlayer());

        role.setWord('test');
        expect(role.word, 'test');
        expect(role.previousWords, []);

        role.setWord('test2');
        expect(role.word, 'test2');
        expect(role.previousWords, ['test']);
      });

      test('should set word', () {
        var role = GarrulousWolf(createPlayer());

        expect(role.isWordValid(''), false);
        expect(role.isWordValid('test'), true);

        role.setWord('test');

        expect(role.isWordValid('test'), false);
      });
    });

    group('Effects', () {
      test('HasWord effect should have correct property values', () {
        Effect effect = HasWordEffect(GarrulousWolf(Player('test')));

        expect(effect.isPermanent, false);
        expect(effect.id, EffectId.hasWord);
      });
    });

    group('Abilities', () {
      var self = createPlayer();
      var ability = GarrulousAbility(GarrulousWolf(self));

      test('should have correct properties values', () {
        expect(ability.targetCount, 1);
        expect(ability.id, AbilityId.word);
        expect(ability.type, AbilityType.active);
        expect(ability.useCount, AbilityUseCount.infinite);
        expect(ability.time, AbilityTime.night);
      });

      test('should add effect to target', () {
        var player = createPlayer();

        ability.callOnTarget(player);

        expect(player.hasEffect(EffectId.hasWord), true);
      });

      test('should only be able to target self', () {
        expect(ability.isTarget(self), true);
      });

      test('should NOT be able to target other players', () {
        expect(ability.isTarget(createPlayer()), false);
      });

      test('should be applied surely to a devoured player', () {
        expect(ability.shouldBeAppliedSurely(self), true);
      });

      test('should be available at any case', () {
        expect(ability.shouldBeAvailable(), true);
      });

      test('should be unskippable', () {
        expect(ability.isUnskippable(), true);
      });

      test('should NOT be used on owner death', () {
        expect(ability.shouldBeUsedOnDeath(), false);
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/knight.dart';

import 'utils.dart';

void main() {
  group('Knight', () {
    group('Role', () {
      var role = Knight(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.knight);
      });

      test('should be a group', () {
        expect(role.isGroup, false);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, knightPriority);
      });

      test('should have a counter ability', () {
        expect(role.hasAbilityOfType(AbilityId.counter), true);
      });

      test('should be called at night', () {
        expect(role.shouldBeCalledAtNight([], 1), true);
      });

      test(
          'should NOT be able to use ability at night when not fatally affected',
          () {
        expect(role.canUseAbilitiesDuringNight(), false);
      });

      test('should be able to use ability at night when fatally affected', () {
        var player = createPlayer(effects: [EffectId.isCursed]);
        var role = Knight(player);

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
      test('isCountered effect should have correct property values', () {
        Effect effect = CounteredEffect(Knight(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isCountered);
      });
    });

    group('Abilities', () {
      Ability ability = CounterAbility(Knight(Player('test')));

      test('should have correct properties values', () {
        expect(ability.targetCount, 1);
        expect(ability.id, AbilityId.counter);
        expect(ability.type, AbilityType.passive);
        expect(ability.useCount, AbilityUseCount.once);
        expect(ability.time, AbilityTime.night);
      });

      test('should add counter effect to target', () {
        var player = Player('test');

        ability.callOnTarget(player);
        expect(player.hasEffect(EffectId.isCountered), true);
      });

      test('should remove fatal effects when used', () {
        var self = createPlayer(effects: [
          EffectId.isCursed,
          EffectId.isDevoured,
        ]);
        var ability = CounterAbility(Knight(self));

        ability.callOnTarget(createPlayer());

        expect(self.hasFatalEffect, false);
      });

      test('should be able to target any player', () {
        expect(ability.isTarget(createPlayer()), true);
      });

      test('should NOT be able to target self', () {
        var self = createPlayer();
        var ability = CounterAbility(Knight(self));

        expect(ability.isTarget(self), false);
      });

      test('should be applied surely at any case', () {
        var player = createPlayer();

        expect(ability.shouldBeAppliedSurely(player), true);
      });

      test('should NOT be available when not fatally affected', () {
        var self = createPlayer();
        var ability = CounterAbility(Knight(self));

        expect(ability.shouldBeAvailable(), false);
      });

      test('should be available when fatally affected', () {
        var self = createPlayer(effects: [EffectId.isCountered]);
        var ability = CounterAbility(Knight(self));

        expect(ability.shouldBeAvailable(), true);
      });

      test('should be skippable when not fatally affected', () {
        var self = createPlayer();
        var ability = CounterAbility(Knight(self));

        expect(ability.isUnskippable(), false);
      });

      test('should be unskippable when fatally affected', () {
        var self = createPlayer(effects: [EffectId.isCountered]);
        var ability = CounterAbility(Knight(self));

        expect(ability.isUnskippable(), true);
      });

      test('should NOT be used on owner death', () {
        expect(ability.shouldBeUsedOnDeath(), false);
      });
    });
  });
}

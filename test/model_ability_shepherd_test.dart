import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/shepherd.dart';

import 'utils.dart';

void main() {
  group('Shepherd', () {
    group('Role', () {
      var role = Shepherd(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.shepherd);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, shepherdPriority);
      });

      test('should have a sheep ability', () {
        expect(role.hasAbilityOfType(AbilityId.sheeps), true);
      });

      test('should be called at night', () {
        expect(role.shouldBeCalledAtNight([], 1), true);
      });

      test('should NOT be called at night when all sheeps have been devoured',
          () {
        var role = Shepherd(Player('test'));

        role.abilities[0].targetCount = 0;

        expect(role.shouldBeCalledAtNight([], 10), false);
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
      test('hasSheep effect should have correct property values', () {
        Effect effect = HasSheepEffect(Shepherd(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.hasSheep);
      });
    });

    group('Abilities', () {
      Ability ability = ShepherdAbility(Shepherd(Player('test')));

      Ability create() {
        return createAbilityFromId(AbilityId.sheeps, Shepherd(Player('test')));
      }

      test('SheepAbility should have correct properties values', () {
        expect(ability.targetCount, 2);
        expect(ability.id, AbilityId.sheeps);
        expect(ability.type, AbilityType.active);
        expect(ability.useCount, AbilityUseCount.infinite);
        expect(ability.time, AbilityTime.night);
      });

      test('should add sheep effect to target', () {
        var player = Player('test');

        ability.callOnTarget(player);
        expect(player.hasEffect(EffectId.hasSheep), true);
      });

      test('should be able to target any player', () {
        expect(ability.isTarget(createPlayer()), true);
      });

      test('should be applied surely at any case', () {
        var player = Player('test');

        expect(ability.shouldBeAppliedSurely(player), true);
      });

      test('should be available when there are sheeps', () {
        var ability = create();
        expect(ability.shouldBeAvailable(), true);
      });

      test('should be unskippable if there are sheeps', () {
        expect(ability.isUnskippable(), true);
      });

      test('should NOT be available when there is no sheeps', () {
        var ability = create();
        ability.targetCount = 0;

        expect(ability.shouldBeAvailable(), false);
      });

      test('should be unskippable', () {
        var ability = create();
        ability.targetCount = 0;

        expect(ability.isUnskippable(), false);
      });

      test('should NOT be used on owner death', () {
        expect(ability.shouldBeUsedOnDeath(), false);
      });
    });
  });
}

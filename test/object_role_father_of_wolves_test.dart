import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/protector.dart';

import 'utils.dart';

void main() {
  group('Father of Wolves', () {
    group('Role', () {
      var role = FatherOfWolves(Player(''));

      test('should have an id', () {
        expect(role.id, RoleId.fatherOfWolves);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, fatherOfWolvesPriority);
      });

      test('should have a infect ability', () {
        expect(role.hasAbilityOfType(AbilityId.infect), true);
      });

      test('should NOT be called at night in the first night', () {
        expect(role.shouldBeCalledAtNight(Game()), false);
      });

      test('should be called at night after the first night', () {
        var game = Game();

        game.currentTurnForTesting = 2;
        expect(role.shouldBeCalledAtNight(game), true);
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
        expect(role.getSupposedInitialTeam(), Team.wolves);
      });
    });

    group('Effects', () {
      test('isInfect effect should have correct property values', () {
        Effect effect = InfectedEffect(Protector(Player('')));

        expect(effect.permanent, true);
        expect(effect.type, EffectId.isInfected);
      });
    });

    group('Abilities', () {
      Ability ability = InfectAbility(Protector(Player('')));

      test('InfectAbility should have correct properties values', () {
        expect(ability.targetCount, 1);
        expect(ability.id, AbilityId.infect);
        expect(ability.type, AbilityType.active);
        expect(ability.useCount, AbilityUseCount.once);
        expect(ability.time, AbilityTime.night);
      });

      test('should add infection effect to target', () {
        var player = createPlayer(effects: [EffectId.isDevoured]);

        ability.callOnTarget(player);
        expect(player.hasEffect(EffectId.isInfected), true);
        expect(player.hasEffect(EffectId.isDevoured), false);
      });

      test('should be able to target a devoured player', () {
        expect(ability.isTarget(createPlayer(effects: [EffectId.isDevoured])),
            true);
      });

      test('should NOT be able to target a non-devoured player', () {
        expect(ability.isTarget(createPlayer()), false);
      });

      test('should NOT be able to target a devoured wolf', () {
        expect(
            ability.isTarget(createPlayer(
              roles: [RoleId.werewolf],
              effects: [EffectId.isDevoured],
            )),
            false);
      });

      test('should be applied surely to a devoured player', () {
        var player = createPlayer(effects: [EffectId.isDevoured]);

        expect(ability.shouldBeAppliedSurely(player), true);
      });

      test('should NOT be applied surely to a non-devoured player', () {
        var player = createPlayer();

        expect(ability.shouldBeAppliedSurely(player), false);
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
}

import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/judge.dart';

import 'utils.dart';

void main() {
  group('Judge', () {
    group('Role', () {
      var role = Judge(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.judge);
      });

      test('should be a wolf', () {
        expect(role.isWolf, false);
      });

      test('should be a group', () {
        expect(role.isGroup, false);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, judgePriority);
      });

      test('should have a judgement ability', () {
        expect(role.hasAbilityOfType(AbilityId.judgement), true);
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
    });

    group('Effects', () {
      test('isJudged effect should have correct property values', () {
        Effect effect = JudgedEffect(Judge(Player('test')));

        expect(effect.isPermanent, false);
        expect(effect.id, EffectId.isJudged);
      });

      test('wasJudged effect should have correct property values', () {
        Effect effect = WasJudgedEffect(Judge(Player('test')));

        expect(effect.isPermanent, false);
        expect(effect.id, EffectId.wasJudged);
      });
    });

    group('Abilities', () {
      Ability ability = JudgementAbility(Judge(Player('test')));

      test('should have correct properties values', () {
        expect(ability.targetCount, 1);
        expect(ability.id, AbilityId.judgement);
        expect(ability.type, AbilityType.active);
        expect(ability.useCount, AbilityUseCount.infinite);
        expect(ability.time, AbilityTime.night);
      });

      test('should add judged effect to target', () {
        var player = Player('test');

        ability.callOnTarget(player);
        expect(player.hasEffect(EffectId.isJudged), true);
      });

      test('should be able to target any player previously non-judged', () {
        expect(ability.isTarget(createPlayer(), 1), true);
      });

      test('should NOT be able to target any player previously judged', () {
        expect(ability.isTarget(createPlayer(effects: [EffectId.wasJudged]), 1),
            false);
      });

      test('should be applied surely at any case', () {
        var player = createPlayer();

        expect(ability.shouldBeAppliedSurely(player), true);
      });

      test('should be available at any case', () {
        expect(ability.shouldBeAvailable(), true);
      });

      test('should be unskippable at any case', () {
        expect(ability.isUnskippable(), true);
      });

      test('should NOT be used on owner death', () {
        expect(ability.shouldBeUsedOnDeath(), false);
      });
    });
  });
}

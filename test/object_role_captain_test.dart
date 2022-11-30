import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/captain.dart';

import 'utils.dart';

void main() {
  group('Captain', () {
    group('Role', () {
      var role = Captain(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.captain);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, captainPriority);
      });

      test('should have an execute ability', () {
        expect(role.hasAbilityOfType(AbilityId.execute), true);
      });

      test('should have a substitute ability', () {
        expect(role.hasAbilityOfType(AbilityId.substitute), true);
      });

      test('should have a talker ability', () {
        expect(role.hasAbilityOfType(AbilityId.talker), true);
      });

      test('should have a inherit ability', () {
        expect(role.hasAbilityOfType(AbilityId.inherit), true);
      });

      test('should be called at night', () {
        expect(role.shouldBeCalledAtNight([], 1), true);
      });

      test('should be able to use ability at night', () {
        expect(role.canUseAbilitiesDuringNight(), true);
      });

      test('should be able to use ability at day', () {
        expect(role.canUseAbilitiesDuringDay(), true);
      });

      test('should NOT be able to use sign with narrator', () {
        expect(role.canUseSignWithNarrator(), false);
      });

      test('should return the correct initial team', () {
        expect(role.getSupposedInitialTeam(), Team.village);
      });
    });

    group('Effects', () {
      test('isExecuted effect should have correct property values', () {
        Effect effect = ExecutedEffect(Captain(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isExecuted);
      });

      test('isSubstituted effect should have correct property values', () {
        Effect effect = SubstitutedEffect(Captain(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isSubstitue);
      });

      test('shouldTalkFirst effect should have correct property values', () {
        Effect effect = ShouldTalkFirstEffect(Captain(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.shouldTalkFirst);
      });

      test('hasInheritedCaptaincy effect should have correct property values',
          () {
        Effect effect = InheritedCaptaincyEffect(Captain(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.hasInheritedCaptaincy);
      });
    });

    group('Abilities', () {
      group('Execute', () {
        Ability ability = ExecuteAbility(Captain(Player('test')));

        test('should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.execute);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.infinite);
          expect(ability.time, AbilityTime.day);
        });

        test('should add execute effect to target', () {
          var player = Player('test');
          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.isExecuted), true);
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

      group('Inherit', () {
        Ability ability = InheritAbility(Captain(Player('test')));

        test('should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.inherit);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.infinite);
          expect(ability.time, AbilityTime.both);
        });

        test('should add effect to target', () {
          var player = Player('test');
          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.hasInheritedCaptaincy), true);
        });

        test('should be able to target any non-fatally affected player', () {
          expect(ability.isTarget(createPlayer()), true);
        });

        test('should NOT be able to target any fatally affected player', () {
          expect(ability.isTarget(createPlayer(effects: [EffectId.isDevoured])),
              false);
        });

        test('should be applied surely at any case', () {
          var player = Player('test');

          expect(ability.shouldBeAppliedSurely(player), true);
        });

        test('should be available when owner is fatally affected', () {
          var ability = InheritAbility(
              Captain(createPlayer(effects: [EffectId.isDevoured])));

          expect(ability.shouldBeAvailable(), true);
        });

        test('should NOT be available when owner is not fatally affected', () {
          var ability = InheritAbility(Captain(createPlayer()));

          expect(ability.shouldBeAvailable(), false);
        });

        test('should be unskippable when owner is fatally affected', () {
          var ability = InheritAbility(
              Captain(createPlayer(effects: [EffectId.isDevoured])));

          expect(ability.isUnskippable(), true);
        });

        test('should be skippable when owner is not fatally affected', () {
          var ability = InheritAbility(Captain(createPlayer()));

          expect(ability.isUnskippable(), false);
        });

        test('should NOT be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), true);
        });
      });

      group('Substitute', () {
        Ability ability = SubstitueAbility(Captain(Player('test')));

        test('should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.substitute);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.infinite);
          expect(ability.time, AbilityTime.night);
        });

        test('should add effect to target', () {
          var player = Player('test');
          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.isSubstitue), true);
        });

        test('should be able to target any player except self', () {
          var self = createPlayer();
          var ability = SubstitueAbility(Captain(self));

          expect(ability.isTarget(createPlayer()), true);
          expect(ability.isTarget(self), false);
        });

        test('should be applied surely at any case', () {
          expect(ability.shouldBeAppliedSurely(createPlayer()), true);
        });

        test('should NOT be available', () {
          expect(ability.shouldBeAvailable(), false);
        });

        test('should NOT be unskippable', () {
          expect(ability.isUnskippable(), false);
        });

        test('should NOT be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), false);
        });
      });

      group('Talker', () {
        Ability ability = TalkerAbility(Captain(Player('test')));

        test('should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.talker);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.infinite);
          expect(ability.time, AbilityTime.night);
        });

        test('should add effect to target', () {
          var player = Player('test');
          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.shouldTalkFirst), true);
        });

        test('should be able to target any player except self', () {
          expect(ability.isTarget(createPlayer()), true);
        });

        test('should be applied surely at any case', () {
          expect(ability.shouldBeAppliedSurely(createPlayer()), true);
        });

        test('should be available when owner is not fatally affected', () {
          expect(ability.shouldBeAvailable(), true);
        });

        test('should NOT be available when owner is fatally affected', () {
          var ability = TalkerAbility(
              Captain(createPlayer(effects: [EffectId.isDevoured])));

          expect(ability.shouldBeAvailable(), false);
        });

        test('should NOT be unskippable', () {
          expect(ability.isUnskippable(), true);
        });

        test('should NOT be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), false);
        });
      });
    });
  });
}

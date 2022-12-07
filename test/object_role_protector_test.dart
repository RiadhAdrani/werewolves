import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/protector.dart';

import 'utils.dart';

void main() {
  group('Protector', () {
    group('Role', () {
      var role = Protector(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.protector);
      });

      test('should be a wolf', () {
        expect(role.isWolf, false);
      });

      test('should be a group', () {
        expect(role.isGroup, false);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, protectorPriority);
      });

      test('should have a protect ability', () {
        expect(role.hasAbilityOfType(AbilityId.protect), true);
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
      test('isProtected effect should have correct property values', () {
        Effect effect = ProtectedEffect(Protector(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isProtected);
      });

      test('wasProtected effect should have correct property values', () {
        Effect effect = WasProtectedEffect(Protector(Player('test')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.wasProtected);
      });
    });

    group('Abilities', () {
      Ability ability = ProtectAbility(Protector(Player('test')));

      test('ProtectAbility should have correct properties values', () {
        expect(ability.targetCount, 1);
        expect(ability.id, AbilityId.protect);
        expect(ability.type, AbilityType.active);
        expect(ability.useCount, AbilityUseCount.infinite);
        expect(ability.time, AbilityTime.night);
      });

      test('should add protection effect to target', () {
        var player = Player('test');

        ability.callOnTarget(player);
        expect(player.hasEffect(EffectId.isProtected), true);
      });

      test('should be able to target a previously non-protected player', () {
        expect(ability.isTarget(createPlayer()), true);
      });

      test('should NOT be able to target a previously-protected player', () {
        expect(ability.isTarget(createPlayer(effects: [EffectId.wasProtected])),
            false);
      });

      test('should be applied surely at any case', () {
        var player = Player('test');

        expect(ability.shouldBeAppliedSurely(player), true);
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

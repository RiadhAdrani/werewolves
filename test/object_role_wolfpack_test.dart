import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

import 'utils.dart';

void main() {
  group('Wolfpack', () {
    group('Role', () {
      var role = Wolfpack([Player('')]);

      test('should have an id', () {
        expect(role.id, RoleId.wolfpack);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, wolfpackPriority);
      });

      test('should have a protect ability', () {
        expect(role.hasAbilityOfType(AbilityId.devour), true);
      });

      test('should be called at night', () {
        expect(role.shouldBeCalledAtNight([], 1), true);
      });

      test('should NOT be called at night when all members are dead', () {
        var player = Player('');
        player.isAlive = false;

        expect(Wolfpack([player]).shouldBeCalledAtNight([], 1), false);
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

      test(
          'should compute if infected player should change its team upon infection',
          () {
        for (var role in RoleId.values) {
          expect(
            Wolfpack.shouldJoinWolfpackUponInfection(
              createPlayer(
                roles: [role],
              ),
            ),
            [RoleId.alien].contains(role) ? false : true,
          );
        }
      });
    });

    group('Effects', () {
      test('isDevoured effect should have correct property values', () {
        Effect effect = DevouredEffect(Wolfpack([Player('')]));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isDevoured);
      });
    });

    group('Abilities', () {
      Ability ability = DevourAbility(Wolfpack([Player('')]));

      test('DevourAbility should have correct properties values', () {
        expect(ability.targetCount, 1);
        expect(ability.id, AbilityId.devour);
        expect(ability.type, AbilityType.active);
        expect(ability.useCount, AbilityUseCount.infinite);
        expect(ability.time, AbilityTime.night);
      });

      test('should add devour effect to target', () {
        var player = Player('test');

        ability.callOnTarget(player);
        expect(player.hasEffect(EffectId.isDevoured), true);
      });

      test('should be applied surely when not protected', () {
        var player = createPlayer();

        expect(ability.shouldBeAppliedSurely(player), true);
      });

      test('should NOT be applied surely when protected', () {
        var player = createPlayer(effects: [EffectId.isProtected]);

        expect(ability.shouldBeAppliedSurely(player), false);
      });

      test('should be available at any case', () {
        expect(ability.shouldBeAvailable(), true);
      });

      test('should be skippable', () {
        expect(ability.isUnskippable(), false);
      });

      test('should NOT be used on owner death', () {
        expect(ability.shouldBeUsedOnDeath(), false);
      });

      test('should be able to target wolves', () {
        expect(ability.isTarget(createPlayer(roles: [RoleId.werewolf])), true);
        expect(ability.isTarget(createPlayer(roles: [RoleId.fatherOfWolves])),
            true);
        expect(ability.isTarget(createPlayer(roles: [RoleId.blackWolf])), true);
        expect(ability.isTarget(createPlayer(roles: [RoleId.garrulousWolf])),
            true);
      });
    });
  });
}

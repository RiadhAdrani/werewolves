import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';
import 'package:werewolves/objects/roles/hunter.dart';

import 'utils.dart';

void main() {
  group('Hunter', () {
    group('Role', () {
      var role = Hunter(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.hunter);
      });

      test('should be a wolf', () {
        expect(role.isWolf, false);
      });
      test('should be a group', () {
        expect(role.isGroup, false);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, hunterPriority);
      });

      test('should have a call sign ability', () {
        expect(role.hasAbilityOfType(AbilityId.callsign), true);
      });

      test('should have a hunt ability', () {
        expect(role.hasAbilityOfType(AbilityId.hunt), true);
      });

      test('should be called at night when without sign', () {
        var role = createRole(id: RoleId.hunter);

        expect(role.shouldBeCalledAtNight([], 1), true);
      });

      test('should be called at night when with fatal effects', () {
        var role = createRole(id: RoleId.hunter);
        role.controller = createPlayer(effects: [EffectId.isDevoured]);

        expect(role.shouldBeCalledAtNight([], 1), true);
      });

      test('should be able to use ability at night when without sign', () {
        var role = createRole(id: RoleId.hunter);

        expect(role.canUseAbilitiesDuringNight(), true);
      });

      test('should be able to use ability at night when with fatal effects',
          () {
        var role = createRole(id: RoleId.hunter);
        role.controller = createPlayer(effects: [EffectId.isDevoured]);

        expect(role.canUseAbilitiesDuringNight(), true);
      });

      test('should be able to use ability at day', () {
        expect(role.canUseAbilitiesDuringDay(), true);
      });

      test('should be able to use sign with narrator', () {
        expect(role.canUseSignWithNarrator(), true);
      });
    });

    group('Effects', () {
      test('isHunted effect should have correct property values', () {
        Effect effect = HuntedEffect(Hunter(Player('test')));

        expect(effect.isPermanent, false);
        expect(effect.id, EffectId.isHunted);
      });

      test('hasCallSignEffect effect should have correct property values', () {
        Effect effect = HasCallSignEffect(Hunter(Player('test')));

        expect(effect.isPermanent, true);
        expect(effect.id, EffectId.hasCallsign);
      });
    });

    group('Abilities', () {
      group('CallSign', () {
        Ability ability = CallSignAbility(Hunter(Player('test')));

        test('should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.callsign);
          expect(ability.type, AbilityType.active);
          expect(ability.useCount, AbilityUseCount.once);
          expect(ability.time, AbilityTime.night);
        });

        test('should add call sign effect to target', () {
          var player = Player('test');
          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.hasCallsign), true);
        });

        test('should NOT be able to target other players', () {
          expect(ability.isTarget(createPlayer()), false);
        });

        test('should be able to target self', () {
          var player = createPlayer();
          var ability = CallSignAbility(Hunter(player));

          expect(ability.isTarget(player), true);
        });

        test('should be applied surely at any case', () {
          var player = Player('test');

          expect(ability.shouldBeAppliedSurely(player), true);
        });

        test(
            'should be available when player has no call sign and is not fatally affected',
            () {
          var player = createPlayer();
          var ability = CallSignAbility(Hunter(player));

          expect(ability.shouldBeAvailable(), true);
        });

        test('should NOT be available when player is fatally affected', () {
          var player = createPlayer(effects: [EffectId.isDevoured]);
          var ability = CallSignAbility(Hunter(player));

          expect(ability.shouldBeAvailable(), false);
        });

        test('should NOT be available when player already have a call sign',
            () {
          var player = createPlayer(effects: [EffectId.hasCallsign]);
          var ability = CallSignAbility(Hunter(player));

          expect(ability.shouldBeAvailable(), false);
        });

        test('should be skippable when player is fatally affected', () {
          var player = createPlayer(effects: [EffectId.isDevoured]);
          var ability = CallSignAbility(Hunter(player));

          expect(ability.isUnskippable(), false);
        });

        test('should be skippable when player has call sign', () {
          var player = createPlayer(effects: [EffectId.hasCallsign]);
          var ability = CallSignAbility(Hunter(player));

          expect(ability.isUnskippable(), false);
        });

        test('should be unskippable when player has no call sign', () {
          var player = createPlayer();
          var ability = CallSignAbility(Hunter(player));

          expect(ability.isUnskippable(), true);
        });

        test('should NOT be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), false);
        });
      });
      group('Hunt', () {
        Ability ability = HuntAbility(Hunter(Player('test')));

        test('should have correct properties values', () {
          expect(ability.targetCount, 1);
          expect(ability.id, AbilityId.hunt);
          expect(ability.type, AbilityType.both);
          expect(ability.useCount, AbilityUseCount.once);
          expect(ability.time, AbilityTime.both);
        });

        test('should add hunt effect only to target when it has a wolf role',
            () {
          var self = createPlayer(roles: [RoleId.hunter]);
          var ability = HuntAbility(Hunter(self));
          var player = createPlayer(roles: [RoleId.werewolf]);

          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.isHunted), true);
          expect(self.hasEffect(EffectId.isHunted), false);
        });

        test(
            'should add hunt effect to target and to self when target has no wolf role',
            () {
          var self = createPlayer(roles: [RoleId.hunter]);
          var ability = HuntAbility(Hunter(self));
          var player = createPlayer(roles: [RoleId.villager]);

          ability.callOnTarget(player);

          expect(player.hasEffect(EffectId.isHunted), true);
          expect(self.hasEffect(EffectId.isHunted), true);
        });

        test('should be able to target other players', () {
          expect(ability.isTarget(createPlayer()), true);
        });

        test('should NOT be able to target self', () {
          var player = createPlayer();
          var ability = createAbilityFromId(AbilityId.hunt, Hunter(player));

          expect(ability.isTarget(player), false);
        });

        test('should be applied surely at any case', () {
          var player = Player('test');

          expect(ability.shouldBeAppliedSurely(player), true);
        });

        test('should NOT be available when player is not fatally affected', () {
          var player = createPlayer();
          var ability = createAbilityFromId(AbilityId.hunt, Hunter(player));

          expect(ability.shouldBeAvailable(), false);
        });

        test('should be available when player is fatally affected', () {
          var player = createPlayer(effects: [EffectId.isCursed]);
          var ability = createAbilityFromId(AbilityId.hunt, Hunter(player));

          expect(ability.shouldBeAvailable(), true);
        });

        test('should be unskippable when player is fatally affected', () {
          var player = createPlayer(effects: [EffectId.isCursed]);
          var ability = createAbilityFromId(AbilityId.hunt, Hunter(player));

          expect(ability.isUnskippable(), true);
        });

        test('should be skippable when player is not fatally affected', () {
          var player = createPlayer(effects: []);
          var ability = createAbilityFromId(AbilityId.hunt, Hunter(player));

          expect(ability.isUnskippable(), false);
        });

        test('should be used on owner death', () {
          expect(ability.shouldBeUsedOnDeath(), true);
        });
      });
    });
  });
}

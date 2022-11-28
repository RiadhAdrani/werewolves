import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/protector.dart';

import 'utils.dart';

void main() {
  group('Black Wolf', () {
    group('Role', () {
      var role = BlackWolf(Player(''));

      test('should have an id', () {
        expect(role.id, RoleId.blackWolf);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, blackWolfPriority);
      });

      test('should have a infect ability', () {
        expect(role.hasAbilityOfType(AbilityId.mute), true);
      });

      test('should NOT be called at night in the first night', () {
        expect(role.shouldBeCalledAtNight(Game()), true);
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
      test('isMuted effect should have correct property values', () {
        Effect effect = MutedEffect(Protector(Player('')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.isMuted);
      });

      test('wasMuted effect should have correct property values', () {
        Effect effect = WasMutedEffect(Protector(Player('')));

        expect(effect.permanent, false);
        expect(effect.type, EffectId.wasMuted);
      });
    });

    group('Abilities', () {
      Ability ability = MuteAbility(BlackWolf(Player('')));

      test('MuteAbility should have correct properties values', () {
        expect(ability.targetCount, 1);
        expect(ability.id, AbilityId.mute);
        expect(ability.type, AbilityType.active);
        expect(ability.useCount, AbilityUseCount.infinite);
        expect(ability.time, AbilityTime.night);
      });

      test('should add mute effect to target', () {
        var player = createPlayer();

        ability.callOnTarget(player);
        expect(player.hasEffect(EffectId.isMuted), true);
      });

      test('should be able to target a previously non-muted player', () {
        expect(ability.isTarget(createPlayer(effects: [])), true);
      });

      test('should NOT be able to target a previously muted player', () {
        expect(ability.isTarget(createPlayer(effects: [EffectId.wasMuted])),
            false);
      });

      test('should be applied surely to a non-protected player', () {
        var player = createPlayer();

        expect(ability.shouldBeAppliedSurely(player), true);
      });

      test('should NOT be applied surely to a protected player', () {
        var player = createPlayer(effects: [EffectId.isProtected]);

        expect(ability.shouldBeAppliedSurely(player), false);
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

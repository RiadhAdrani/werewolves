import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';

import 'utils.dart';

void main() {
  group('Ability', () {
    Ability create() {
      return useAbilityHelper(AbilityId.infect).create(
        FatherOfWolves(Player('')),
      );
    }

    test('should exhaust ability use count', () {
      var ability = create();

      ability.use([Player('')], 0);

      expect(ability.useCount, AbilityUseCount.none);
    });

    test('should register the turn', () {
      var ability = create();

      ability.use([Player('')], 0);

      expect(ability.wasUsedInTurn(0), true);
    });

    test('should throw when the number of targets is more than the max allowed',
        () {
      var ability = create();

      expect(
          () => ability.use([Player(''), Player('')], 0),
          throwsA(
              '[Exception] The number of targets is superior to the maximum allowed.'));
    });

    test('should be applied', () {
      var ability = create();
      var player = createPlayer(effects: []);

      ability.use([player], 0);

      expect(player.hasEffect(EffectId.isInfected), true);
    });

    test('should NOT be applied', () {
      var ability = create();
      var player = createPlayer(effects: [EffectId.isProtected]);

      ability.use([player], 0);

      expect(player.hasEffect(EffectId.isInfected), false);
    });
  });
}

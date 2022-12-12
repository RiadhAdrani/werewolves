import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/errors.dart';
import 'package:werewolves/utils/utils.dart';

void main() {
  group('Utilities', () {
    List<Role> roles = [];
    test('should check if player name is valid', () {
      for (var name in ['name', 'Wolf', 'XxVillagerxX']) {
        {
          expect(checkPlayerName(name, roles), true);
        }
      }
    });

    test('should refuse bad names', () {
      for (var name in ['na+me', 'n\$me']) {
        {
          expect(checkPlayerName(name, roles), false);
        }
      }
    });

    test('should throw an error', () {
      expect(() => throwException('Error'), throwsA('[Exception] Error'));
    });

    group('isSelectionValid', () {
      const cases = [
        [
          [
            RoleId.alien,
          ],
          false,
          'Player count is too low',
        ],
        [
          [
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
          ],
          false,
          'Wolves count is higher than the villagers count',
        ],
        [
          [
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.alien,
            RoleId.alien,
            RoleId.alien,
            RoleId.alien,
          ],
          false,
          'Solos count is higher than the villagers count',
        ],
        [
          [
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.alien,
            RoleId.alien,
            RoleId.alien,
            RoleId.alien,
          ],
          false,
          'Solos count is higher than the wolves count',
        ],
        [
          [
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.werewolf,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.villager,
            RoleId.alien,
          ],
          true,
          null,
        ]
      ];

      for (var testCase in cases) {
        test('should return valid = ${testCase[1]} && msg = ${testCase[2]}',
            () {
          var res = isSelectionValid(testCase[0] as List<RoleId>);

          expect(res.valid, testCase[1]);
          expect(res.msg, testCase[2]);
        });
      }
    });
  });
}

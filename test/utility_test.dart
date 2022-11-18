import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/role.dart';
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
      for (var name in ['na+me']) {
        {
          expect(checkPlayerName(name, roles), false);
        }
      }
    });
  });
}

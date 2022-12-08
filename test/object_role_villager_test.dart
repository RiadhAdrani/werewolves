import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/villager.dart';

void main() {
  group('Werewolf', () {
    group('Role', () {
      var role = Villager(Player('test'));

      test('should have an id', () {
        expect(role.id, RoleId.villager);
      });

      test('should be a wolf', () {
        expect(role.isWolf, false);
      });

      test('should be a group', () {
        expect(role.isGroup, false);
      });

      test('should have a calling priority', () {
        expect(role.callingPriority, -1);
      });

      test('should have a infect ability', () {
        expect(role.abilities.length, 0);
      });

      test('should NOT be called at night in the first night', () {
        expect(role.shouldBeCalledAtNight([], 1), false);
      });

      test('should be able to use ability at night', () {
        expect(role.canUseAbilitiesDuringNight(), false);
      });

      test('should NOT be able to use ability at day', () {
        expect(role.canUseAbilitiesDuringDay(), false);
      });

      test('should NOT be able to use sign with narrator', () {
        expect(role.canUseSignWithNarrator(), false);
      });
    });
  });
}

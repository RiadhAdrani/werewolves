import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/distribution.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/utils.dart';

List<Role> createGameList({
  List<RoleId>? roles,
}) {
  List<DistributedRole> picked = (roles ?? RoleId.values)
      .where((element) => !useRole(element).create([Player('test')]).isGroup)
      .toList()
      .map((id) => DistributedRole(id, useId()))
      .toList();

  return transformRolesFromPickedList(picked);
}

void main() {
  group('Game', () {
    group('nextIndex', () {
      List<Role> roles = [];
      List<Role> available = [];
      List<Role> called = [];

      void customSetup({List<RoleId>? input}) {
        roles = createGameList(roles: input);
        available = [...roles];
        called = [];
      }

      Role? useNext({int times = 1, int turn = 0, Function(Role?)? effect}) {
        Role? current;

        for (int i = 0; i < times; i++) {
          int index = nextIndex(current, turn, roles, available, called);

          if (index == -1) {
            current = null;
          } else {
            current = available[index];

            available.removeAt(index);
            called.add(current);
          }

          if (effect != null) {
            effect(current);
          }
        }

        return current;
      }

      setUp(() {
        customSetup();
      });

      test('should return correct index', () {
        customSetup(input: [
          RoleId.protector,
          RoleId.werewolf,
          RoleId.witch,
          RoleId.villager,
          RoleId.captain,
        ]);

        int index = nextIndex(null, 0, roles, available, called);

        expect(index, 0);
      });

      test('should return -1 when all available are called', () {
        List<RoleId> pool = [
          RoleId.protector,
          RoleId.werewolf,
          RoleId.witch,
          RoleId.captain,
        ];

        customSetup(input: pool);

        Role? current = useNext(times: pool.length + 1);

        int index = nextIndex(current, 0, roles, available, called);

        expect(index, -1);
      });

      test('should return next as expected', () {
        List<RoleId> pool = [
          RoleId.werewolf,
          RoleId.captain,
          RoleId.protector,
          RoleId.witch,
        ];

        List<RoleId> order = [];

        customSetup(input: pool);

        useNext(
            times: pool.length + 1,
            effect: (Role? role) {
              if (role != null) {
                order.add(role.id);
              }
            });

        expect(order, [
          RoleId.protector,
          RoleId.wolfpack,
          RoleId.witch,
          RoleId.captain,
        ]);
      });

      test('should call roles with same priority', () {
        List<RoleId> pool = [
          RoleId.werewolf,
          RoleId.captain,
          RoleId.protector,
          RoleId.captain,
          RoleId.witch,
        ];

        List<RoleId> order = [];

        customSetup(input: pool);

        useNext(
            times: pool.length + 1,
            effect: (Role? role) {
              if (role != null) {
                order.add(role.id);
              }
            });

        expect(order, [
          RoleId.protector,
          RoleId.wolfpack,
          RoleId.witch,
          RoleId.captain,
          RoleId.captain,
        ]);
      });

      test('should not call non-callable roles', () {
        List<RoleId> pool = [
          RoleId.werewolf,
          RoleId.captain,
          RoleId.protector,
          RoleId.villager,
          RoleId.witch,
        ];

        List<RoleId> order = [];

        customSetup(input: pool);

        useNext(
            times: pool.length + 1,
            effect: (Role? role) {
              if (role != null) {
                order.add(role.id);
              }
            });

        expect(order, [
          RoleId.protector,
          RoleId.wolfpack,
          RoleId.witch,
          RoleId.captain,
        ]);
      });
    });
  });
}

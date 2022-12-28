import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/distribution.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/utils.dart';

void main() {
  group('DistributionModel', () {
    DistributionModel model = DistributionModel([...RoleId.values]);

    setUp(() {
      model = DistributionModel([...RoleId.values]);
    });

    test('initial state', () {
      expect(model.canPick, true);
      expect(model.done, false);
      expect(model.picked, 0);
      expect(model.size, RoleId.values.length);
    });

    test('should not be able to pick when remaining is empty', () {
      model.roles = [];

      expect(model.pick(), null);
      expect(model.canPick, false);
    });

    test('should be done when all roles are picked', () {
      while (model.canPick) {
        model.assign(model.pick()!, useId());
      }

      expect(model.done, true);
    });

    test('should assign player to role', () {
      expect(model.assign(model.pick()!, 'test'), true);
      expect(model.distributed[0].player, 'test');
      expect(model.roles.length, RoleId.values.length - 1);
      expect(model.picked, 1);
    });

    test('should not assign player with existing role', () {
      model.assign(model.pick()!, 'test');

      expect(model.assign(model.pick()!, 'test'), false);
    });

    test('should not assign player with empty name', () {
      expect(model.assign(model.pick()!, ''), false);
    });

    test('should reset lists', () {
      model.assign(model.pick()!, 'test');
      model.assign(model.pick()!, 'test2');

      model.reset();

      expect(model.roles, RoleId.values);
      expect(model.distributed, []);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selection.dart';

void main() {
  group('Selection', () {
    var controller = SelectionModel();

    tearDown(() {
      controller = SelectionModel();
    });

    test('should get role count', () {
      expect(controller.getCount(RoleId.villager), 0);

      controller.add(RoleId.villager);
      expect(controller.getCount(RoleId.villager), 1);

      controller.add(RoleId.villager);
      expect(controller.getCount(RoleId.villager), 2);
    });

    test('should add element', () {
      controller.add(RoleId.villager);

      expect(controller.items, [RoleId.villager]);
    });

    test('should add element when role is not unique', () {
      controller.add(RoleId.villager);
      controller.add(RoleId.villager);

      expect(controller.items, [RoleId.villager, RoleId.villager]);
    });

    test('should Not add element when role is unique', () {
      controller.add(RoleId.protector);
      controller.add(RoleId.protector);

      expect(controller.items, [RoleId.protector]);
    });

    test('should check if a role is picked or not', () {
      expect(controller.isPicked(RoleId.villager), false);

      controller.add(RoleId.villager);

      expect(controller.isPicked(RoleId.villager), true);
    });

    test('should remove element', () {
      controller.add(RoleId.villager);
      controller.remove(RoleId.villager);

      expect(controller.items, []);
    });
  });
}

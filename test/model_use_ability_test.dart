import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/use_ability_model.dart';
import 'package:werewolves/objects/roles/protector.dart';

void main() {
  group("UseAbility", () {
    var player = Player('player');
    var owner = Protector(player);
    var model = UseAbilityModel(owner.getAbilityOfType(AbilityId.protect)!);

    setUp(() {
      model = UseAbilityModel(owner.getAbilityOfType(AbilityId.protect)!);
    });

    group("add", () {
      test("should add player to selected list", () {
        var target = Player('target');

        model.add(target);

        expect(model.selected, [target]);
      });

      test(
          "should remove existing player and add new player to selected list if the maximum number reached.",
          () {
        var target = Player('target');
        var target2 = Player('target');

        model.add(target);
        model.add(target2);

        expect(model.selected, [target2]);
      });
    });

    group("remove", () {
      test("should remove player from selection", () {
        var target = Player('target');

        model.add(target);
        model.remove(target);
        expect(model.selected, []);
      });
    });

    group("isSelected", () {
      test("should return true: player is selected", () {
        var target = Player('target');

        model.add(target);

        expect(model.isSelected(target), true);
      });
      test("should return false: player is not selected", () {
        var target = Player('target');

        expect(model.isSelected(target), false);
      });
    });

    group("toggle", () {
      test("should toggle player selection", () {
        var target = Player('target');

        model.toggle(target);
        expect(model.isSelected(target), true);

        model.toggle(target);
        expect(model.isSelected(target), false);
      });
    });
  });
}

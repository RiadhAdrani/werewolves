import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/use_alien_ability_model.dart';

import 'model_game_test.dart';

void main() {
  group("UseAbility", () {
    var roles = createGameList();
    var players = extractPlayers(roles);

    var model = UseAlienAbilityModel(players, roles);

    setUp(() {
      model = UseAlienAbilityModel(players, roles);
    });

    group("change", () {
      test("should change item guess", () {
        var item = model.items[0];

        model.change(item, RoleId.villager);

        expect(item.guess, RoleId.villager);
        expect(item.selected, true);
      });
    });

    group("toggle", () {
      test("should not change item selection when guess is null", () {
        var item = model.items[0];

        model.toggle(item);

        expect(item.guess, null);
        expect(item.selected, false);
      });

      test("should change item selection", () {
        var item = model.items[0];

        model.change(item, RoleId.villager);
        expect(item.selected, true);

        model.toggle(item);
        expect(item.selected, false);

        model.toggle(item);
        expect(item.selected, true);
      });
    });
  });
}

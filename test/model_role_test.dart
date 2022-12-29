import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/distribution.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';
import 'package:werewolves/utils/utils.dart';

import 'utils.dart';

void main() {
  group('Role', () {
    for (var item in [
      [
        [AbilityId.callsign],
        AbilityId.protect,
        false,
      ],
      [
        [AbilityId.protect],
        AbilityId.protect,
        true
      ]
    ]) {
      var role = createRole(abilities: item[0] as List<AbilityId>);

      test('should get if ability exist : ${item[1]} => ${item[2]}', () {
        expect(role.hasAbilityOfType(item[1] as AbilityId), item[2]);
      });
    }

    for (var item in [
      [
        [AbilityId.protect],
        AbilityId.protect,
      ],
      [
        [AbilityId.devour, AbilityId.clairvoyance, AbilityId.protect],
        AbilityId.protect,
      ]
    ]) {
      var role = createRole(abilities: item[0] as List<AbilityId>);

      test('should get ability of type ${item[1]}', () {
        var ab = (role.getAbilityOfType(item[1] as AbilityId)) as Ability;

        expect(ab.id, item[1]);
      });
    }

    for (var item in [
      [
        [AbilityId.protect],
        AbilityId.devour,
      ],
      [
        [AbilityId.devour, AbilityId.clairvoyance, AbilityId.protect],
        AbilityId.callsign,
      ]
    ]) {
      var role = createRole(abilities: item[0] as List<AbilityId>);

      test('should return null when ability does not exist', () {
        var ab = role.getAbilityOfType(item[1] as AbilityId);

        expect(ab, null);
      });
    }

    test('should return if the user has an unused ability of a given type', () {
      var role = createRole(abilities: [AbilityId.revive, AbilityId.counter]);
      role.abilities[0].use([Player('test')], 0);

      expect(role.hasUnusedAbilityOfType(AbilityId.revive), false);
      expect(role.hasUnusedAbilityOfType(AbilityId.counter), true);
    });

    group('RoleSingular', () {
      var role = createRole(id: RoleId.alien) as RoleSingular;

      test('should not be group', () {
        expect(role.isGroup, false);
      });

      test('should add role to player', () {
        expect(role.player.hasRole(RoleId.alien), true);
      });

      test('should compute player name', () {
        expect(role.getPlayerName(), 'test');
      });

      test('should determine if player is fatally wounded', () {
        expect(role.playerIsFatallyWounded(), false);
        role.player.addEffect(
          createEffectFromId(
            EffectId.isDevoured,
            Wolfpack([Player('source')]),
          ),
        );
        expect(role.playerIsFatallyWounded(), true);
        role.player.removeEffectsOfType(EffectId.isDevoured);
      });

      test('should determine if role is obsolete', () {
        expect(role.isObsolete(), false);
        role.setObsolete();
        expect(role.isObsolete(), true);
      });

      var group = Villager(Player('0'));
      var p1 = Player('1');
      var p2 = Player('2');

      test('setPlayer should add player/role', () {
        group.setPlayer(p1);

        expect(group.player, p1);
        expect(p1.hasRole(RoleId.villager), true);
      });

      test('setPlayer should remove/replace player/role', () {
        group.setPlayer(p2);

        expect(group.player != p1, true);
        expect(p1.hasRole(RoleId.villager), false);

        expect(p2.hasRole(RoleId.villager), true);
        expect(group.player, p2);
      });
    });

    group('RoleGroup', () {
      var role = useRole(RoleId.wolfpack)
          .create([Player('1'), Player('2'), Player('3')]);

      test('should be group role', () {
        expect(role.isGroup, true);
      });

      test('members should have the role', () {
        for (var member in role.player) {
          expect(member.hasRole(RoleId.wolfpack), true);
        }
      });

      test('should format players name', () {
        expect(role.getPlayerName(), '1 | 2 | 3');
      });

      test('should compute if role is fatally wounded', () {
        expect(role.playerIsFatallyWounded(), false);
        role.player[0].addEffect(
          createEffectFromId(
            EffectId.isDevoured,
            Wolfpack([Player('source')]),
          ),
        );
        expect(role.playerIsFatallyWounded(), false);

        for (var member in role.player) {
          member.addEffect(
            createEffectFromId(
              EffectId.isDevoured,
              Wolfpack([Player('source')]),
            ),
          );
        }
        expect(role.playerIsFatallyWounded(), true);

        for (var member in role.player) {
          member.removeEffectsOfType(EffectId.isDevoured);
        }
      });

      test('should determine if role is obsolete', () {
        expect(role.isObsolete(), false);
        for (var member in role.player) {
          member.isAlive = false;
        }
        expect(role.isObsolete(), true);
      });

      var group = Wolfpack([]);
      var p1 = Player('1');
      var p2 = Player('2');

      test('setPlayer should add players/role', () {
        group.setPlayer([p1]);

        expect(group.player.contains(p1), true);
        expect(p1.hasRole(RoleId.wolfpack), true);
      });

      test('setPlayer should remove/replace player/role', () {
        group.setPlayer([p2]);

        expect(group.player.contains(p1), false);
        expect(p1.hasRole(RoleId.wolfpack), false);

        expect(p2.hasRole(RoleId.wolfpack), true);
        expect(group.player.contains(p2), true);
      });
    });

    test('should not add wolfpack as a singular role list', () {
      List<RoleId> roles = [
        RoleId.villager,
        RoleId.seer,
        RoleId.witch,
        RoleId.protector,
        RoleId.captain,
        RoleId.werewolf,
        RoleId.alien,
      ];

      var compiled = createSingularRolesListFromId(roles);

      Role? target;

      try {
        target = compiled.firstWhere((role) => role.id == RoleId.wolfpack);
      } catch (e) {
        target = null;
      }

      expect(target, null);
    });

    test('should transform picked list to game list', () {
      List<RoleId> roles = [
        RoleId.villager,
        RoleId.seer,
        RoleId.witch,
        RoleId.protector,
        RoleId.captain,
        RoleId.werewolf,
        RoleId.alien,
      ];

      var compiled = transformRolesFromPickedList(
          roles.map((id) => DistributedRole(id, useId())).toList());

      // Should add singular roles
      for (var role in compiled) {
        if (role.id != RoleId.wolfpack) {
          expect(roles.contains(role.id), true);
        }
      }
    });

    test('should throw when there is no wolf role', () {
      List<RoleId> roles = [
        RoleId.villager,
        RoleId.seer,
        RoleId.witch,
        RoleId.protector,
        RoleId.captain,
        RoleId.alien,
      ];

      void callback() => transformRolesFromPickedList(
          roles.map((id) => DistributedRole(id, useId())).toList());

      expect(callback, throwsA('Game cannot start without a wolfpack !'));
    });

    test('should add all wolves to the wolfpack', () {
      List<RoleId> roles = [
        RoleId.villager,
        RoleId.seer,
        RoleId.witch,
        RoleId.protector,
        RoleId.captain,
        RoleId.alien,
        RoleId.werewolf,
        RoleId.fatherOfWolves
      ];

      var compiled = transformRolesFromPickedList(
          roles.map((id) => DistributedRole(id, useId())).toList());

      var wolfpack = compiled
          .firstWhere((element) => element.id == RoleId.wolfpack) as RoleGroup;

      expect(wolfpack.player.length, 2);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

void main() {
  Role useTestRole({
    RoleId id = RoleId.villager,
    List<AbilityId> abilities = const [],
  }) {
    Role role = createRoleFromId(id, Player('test'));

    for (var ability in abilities) {
      role.abilities.add(createAbilityFromId(ability, role));
    }

    return role;
  }

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
      var role = useTestRole(abilities: item[0] as List<AbilityId>);

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
      var role = useTestRole(abilities: item[0] as List<AbilityId>);

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
      var role = useTestRole(abilities: item[0] as List<AbilityId>);

      test('should return null when ability does not exist', () {
        var ab = role.getAbilityOfType(item[1] as AbilityId);

        expect(ab, null);
      });
    }

    test('should return if the user has an unused ability of a given type', () {
      var role = useTestRole(abilities: [AbilityId.revive, AbilityId.counter]);
      role.abilities[0].use([Player('test')], 0);

      expect(role.hasUnusedAbilityOfType(AbilityId.revive), false);
      expect(role.hasUnusedAbilityOfType(AbilityId.counter), true);
    });

    test('should run implemented abstract functions (RoleSingular)', () {
      var role = useTestRole(id: RoleId.alien) as RoleSingular;

      // isGroup variable
      expect(role.isGroup, false);

      // add role to player
      expect(role.player.hasRole(RoleId.alien), true);

      // getPlayerName
      expect(role.getPlayerName(), 'test');

      // playerIsFatallyWounded
      expect(role.playerIsFatallyWounded(), false);
      role.player.addEffect(
        createEffectFromId(
          EffectId.isDevoured,
          Player('source'),
        ),
      );
      expect(role.playerIsFatallyWounded(), true);
      role.player.removeEffectsOfType(EffectId.isDevoured);

      // isObsolete && setObsolete
      expect(role.isObsolete(), false);
      role.setObsolete();
      expect(role.isObsolete(), true);
    });

    test('should not be a group role (RoleGroup)', () {
      var role = Wolfpack([Player('1'), Player('2'), Player('3')]);

      // isGroup variable
      expect(role.isGroup, true);

      // add role to players
      for (var member in role.player) {
        expect(member.hasRole(RoleId.wolfpack), true);
      }

      // getPlayerName
      expect(role.getPlayerName(), '1 | 2 | 3');

      // playerIsFatallyWounded
      expect(role.playerIsFatallyWounded(), false);
      role.player[0].addEffect(
        createEffectFromId(
          EffectId.isDevoured,
          Player('source'),
        ),
      );
      expect(role.playerIsFatallyWounded(), false);

      for (var member in role.player) {
        member.addEffect(
          createEffectFromId(
            EffectId.isDevoured,
            Player('source'),
          ),
        );
      }
      expect(role.playerIsFatallyWounded(), true);

      for (var member in role.player) {
        member.removeEffectsOfType(EffectId.isDevoured);
      }

      // isObsolete && setObsolete
      expect(role.isObsolete(), false);
      for (var member in role.player) {
        member.isAlive = false;
      }
      expect(role.isObsolete(), true);
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

      var compiled =
          prepareGameRolesFromPickedList(createSingularRolesListFromId(roles));

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

      void callback() =>
          prepareGameRolesFromPickedList(createSingularRolesListFromId(roles));

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

      var compiled =
          prepareGameRolesFromPickedList(createSingularRolesListFromId(roles));

      var wolfpack = compiled
          .firstWhere((element) => element.id == RoleId.wolfpack) as RoleGroup;

      expect(wolfpack.player.length, 2);
    });
  });
}

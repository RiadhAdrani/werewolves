import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/shepherd.dart';

import 'utils.dart';

void main() {
  group('Resolve player main role', () {
    test('should return the only single role', () {
      Player player = createPlayer(roles: [RoleId.protector]);

      expect(resolveMainRole(player).id, RoleId.protector);
    });

    test(
        'should return the singular role instead of the group one in case of two roles.',
        () {
      Player player = createPlayer(roles: [RoleId.captain, RoleId.wolfpack]);

      expect(resolveMainRole(player).id, RoleId.captain);
    });

    test(
        'should return the non-captain role in case of two singular role with one of them is the captain',
        () {
      Player player = createPlayer(roles: [RoleId.captain, RoleId.werewolf]);

      expect(resolveMainRole(player).id, RoleId.werewolf);
    });

    test('should return the role that is non-group and non-captain', () {
      Player player =
          createPlayer(roles: [RoleId.alien, RoleId.captain, RoleId.wolfpack]);

      expect(resolveMainRole(player).id, RoleId.alien);
    });
  });

  group('Resolve player team', () {
    test('should resolve to alien', () {
      expect(createPlayer(roles: [RoleId.alien]).team, Team.alien);
    });

    test('should resolve to wolves', () {
      expect(createPlayer(roles: [RoleId.wolfpack]).team, Team.wolves);
    });

    test('should resolve to villager', () {
      expect(createPlayer().team, Team.village);
    });
  });

  group('Player', () {
    for (var item in [
      [createPlayer(), false],
      [
        createPlayer(effects: [EffectId.isDevoured]),
        true
      ],
      [
        createPlayer(effects: [EffectId.hasSheep, EffectId.isDevoured]),
        true
      ]
    ]) {
      test('should determine if the player has a fatal effect : ${item[1]}',
          () {
        expect((item[0] as Player).hasFatalEffect, item[1]);
      });
    }

    test('should remove fatal effects', () {
      Player player = createPlayer(effects: [
        EffectId.isDevoured,
        EffectId.shouldTalkFirst,
        EffectId.isCursed,
        EffectId.hasSheep,
        EffectId.isCountered
      ]);

      player.removeFatalEffects([EffectId.isCountered]);

      expect(player.effects.length, 3);
      expect(player.hasEffect(EffectId.isCountered), true);
      expect(player.hasEffect(EffectId.isDevoured), false);
      expect(player.hasEffect(EffectId.isCursed), false);
    });

    test('should add effect', () {
      Player player = createPlayer();
      var effect = createEffectFromId(EffectId.hasSheep, Shepherd(player));

      player.addEffect(effect);

      expect(player.effects.contains(effect), true);
    });

    test('should determine if an effect is present or not', () {
      Player player = createPlayer(effects: [
        EffectId.hasCallsign,
        EffectId.isDevoured,
        EffectId.isCountered,
      ]);

      expect(player.hasEffect(EffectId.isDevoured), true);
    });

    test('should remove all effects of a given type', () {
      Player player = createPlayer(roles: [], effects: [
        EffectId.hasCallsign,
        EffectId.isDevoured,
        EffectId.isCountered,
      ]);

      player.removeEffectsOfType(EffectId.isDevoured);

      expect(player.hasEffect(EffectId.isDevoured), false);
    });

    test('should determine if the player has a role of type', () {
      expect(
        createPlayer(roles: [RoleId.captain]).hasRole(RoleId.captain),
        true,
      );

      expect(
        createPlayer(roles: [RoleId.captain]).hasRole(RoleId.villager),
        false,
      );
    });

    test('should add role', () {
      Player player = createPlayer(roles: []);

      player.addRole(Captain(player));

      expect(player.roles.length, 1);
    });

    test('should remove role of given type', () {
      Player player = createPlayer(roles: [RoleId.villager, RoleId.captain]);

      player.removeRole(RoleId.captain);

      expect(player.hasRole(RoleId.captain), false);
      expect(player.roles.length, 1);
    });

    test('should remove group role', () {
      Player player = createPlayer(roles: [
        RoleId.villager,
        RoleId.wolfpack,
        RoleId.captain,
      ]);

      player.removeRole(RoleId.wolfpack);

      expect(player.hasRole(RoleId.wolfpack), false);
      expect(player.hasRole(RoleId.villager), true);
      expect(player.hasRole(RoleId.captain), true);
    });

    test('should determine if there is a wolf role', () {
      expect(
        createPlayer(roles: [RoleId.werewolf, RoleId.wolfpack]).hasWolfRole,
        true,
      );

      expect(
        createPlayer(roles: [RoleId.alien]).hasWolfRole,
        false,
      );
    });

    test('should determine if there is a group role', () {
      expect(
        createPlayer(roles: [RoleId.werewolf, RoleId.wolfpack]).hasGroupRole,
        true,
      );

      expect(
        createPlayer(roles: [RoleId.alien]).hasGroupRole,
        false,
      );
    });

    test('should determine if a player is dead or alive', () {
      Player player = createPlayer();

      expect(player.isDead, false);

      player.isAlive = false;

      expect(player.isDead, true);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/villager.dart';

void main() {
  Player useTestPlayer({
    List<RoleId> roles = const [RoleId.villager],
    List<EffectId> effects = const [],
    Player? effectSource,
  }) {
    Player player = Player('test');

    for (var id in roles) {
      player.addRole(createRoleFromId(id, player));
    }

    for (var id in effects) {
      player.addEffect(createEffectFromId(id, Villager(Player('dummy'))));
    }

    return player;
  }

  group('Resolve player main role', () {
    test('should return the only single role', () {
      Player player = useTestPlayer(roles: [RoleId.protector]);

      expect(resolveMainRole(player).id, RoleId.protector);
    });

    test(
        'should return the singular role instead of the group one in case of two roles.',
        () {
      Player player = useTestPlayer(roles: [RoleId.captain, RoleId.wolfpack]);

      expect(resolveMainRole(player).id, RoleId.captain);
    });

    test(
        'should return the non-captain role in case of two singular role with one of them is the captain',
        () {
      Player player = useTestPlayer(roles: [RoleId.captain, RoleId.werewolf]);

      expect(resolveMainRole(player).id, RoleId.werewolf);
    });

    test('should return the role that is non-group and non-captain', () {
      Player player =
          useTestPlayer(roles: [RoleId.alien, RoleId.captain, RoleId.wolfpack]);

      expect(resolveMainRole(player).id, RoleId.alien);
    });
  });

  group('Player', () {
    for (var item in [
      [useTestPlayer(), false],
      [
        useTestPlayer(effects: [EffectId.isDevoured]),
        true
      ],
      [
        useTestPlayer(effects: [EffectId.hasSheep, EffectId.isDevoured]),
        true
      ]
    ]) {
      test('should determine if the player has a fatal effect : ${item[1]}',
          () {
        expect((item[0] as Player).hasFatalEffect, item[1]);
      });
    }

    test('should remove fatal effects', () {
      Player player = useTestPlayer(effects: [
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

    for (var team in [Team.alien, Team.wolves, Team.wolves]) {
      test('should change player team', () {
        Player player = useTestPlayer();
        player.changeTeam(team);

        expect(player.team, team);
      });
    }

    test('should add effect', () {
      Player player = useTestPlayer();
      var effect = createEffectFromId(EffectId.hasSheep, Shepherd(player));

      player.addEffect(effect);

      expect(player.effects.contains(effect), true);
    });

    test('should determine if an effect is present or not', () {
      Player player = useTestPlayer(effects: [
        EffectId.hasCallsign,
        EffectId.isDevoured,
        EffectId.isCountered,
      ]);

      expect(player.hasEffect(EffectId.isDevoured), true);
    });

    test('should remove all effects of a given type', () {
      Player player = useTestPlayer(roles: [], effects: [
        EffectId.hasCallsign,
        EffectId.isDevoured,
        EffectId.isCountered,
      ]);

      player.removeEffectsOfType(EffectId.isDevoured);

      expect(player.hasEffect(EffectId.isDevoured), false);
    });

    test('should determine if the player has a role of type', () {
      expect(
        useTestPlayer(roles: [RoleId.captain]).hasRole(RoleId.captain),
        true,
      );

      expect(
        useTestPlayer(roles: [RoleId.captain]).hasRole(RoleId.villager),
        false,
      );
    });

    test('should add role', () {
      Player player = useTestPlayer(roles: []);

      player.addRole(Captain(player));

      expect(player.roles.length, 1);
    });

    test('should remove role of given type', () {
      Player player = useTestPlayer(roles: [RoleId.villager, RoleId.captain]);

      player.removeRolesOfType(RoleId.captain);

      expect(player.hasRole(RoleId.captain), false);
      expect(player.roles.length, 1);
    });

    test('should remove group role', () {
      Player player = useTestPlayer(roles: [
        RoleId.villager,
        RoleId.wolfpack,
        RoleId.captain,
      ]);

      player.removeRolesOfType(RoleId.wolfpack);

      expect(player.hasRole(RoleId.wolfpack), false);
      expect(player.hasRole(RoleId.villager), true);
      expect(player.hasRole(RoleId.captain), true);
    });

    test('should determine if there is a wolf role', () {
      expect(
        useTestPlayer(roles: [RoleId.werewolf, RoleId.wolfpack]).hasWolfRole,
        true,
      );

      expect(
        useTestPlayer(roles: [RoleId.alien]).hasWolfRole,
        false,
      );
    });

    test('should determine if there is a group role', () {
      expect(
        useTestPlayer(roles: [RoleId.werewolf, RoleId.wolfpack]).hasGroupRole,
        true,
      );

      expect(
        useTestPlayer(roles: [RoleId.alien]).hasGroupRole,
        false,
      );
    });

    test('should determine if a player is dead or alive', () {
      Player player = useTestPlayer();

      expect(player.isDead, false);

      player.isAlive = false;

      expect(player.isDead, true);
    });
  });
}

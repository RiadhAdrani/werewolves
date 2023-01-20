import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/distribution.dart';
import 'package:werewolves/models/effect.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/utils.dart';

import 'utils.dart';

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

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('Game', () {
    MockBuildContext context = MockBuildContext();

    setUp(() {
      context = MockBuildContext();
    });

    group('nextIndex', () {
      List<Role> roles = [];
      List<Role> available = [];
      List<Role> called = [];

      void customSetup({List<RoleId>? input}) {
        roles = createGameList(roles: input);
        available = [...roles];
        called = [];
      }

      Role? useNext({int times = 1, Function(Role?)? effect}) {
        Role? current;

        for (int i = 0; i < times; i++) {
          int index = nextIndex(current, roles, available, called);

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

        int index = nextIndex(null, roles, available, called);

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

        int index = nextIndex(current, roles, available, called);

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

    group('calculateMandatoryEffects', () {
      test('should return isProtected effect', () {
        var role = useRole(RoleId.protector).create([Player('test')]);
        var roles = [role];
        var res = calculateMandatoryEffects(roles, 0);

        expect(res.map((e) => e.id).toList(), [EffectId.isProtected]);
        expect(res.map((e) => e.role).toList(), [role]);
      });

      test('should return isSeen effect', () {
        var role = useRole(RoleId.seer).create([Player('test')]);
        var roles = [role];
        var res = calculateMandatoryEffects(roles, 0);

        expect(res.map((e) => e.id).toList(), [EffectId.isSeen]);
        expect(res.map((e) => e.role).toList(), [role]);
      });

      test('should return shouldTalk effect', () {
        var role = useRole(RoleId.captain).create([Player('test')]);
        var roles = [role];
        var res = calculateMandatoryEffects(roles, 0);

        expect(res.map((e) => e.id).toList(), [EffectId.shouldTalkFirst]);
        expect(res.map((e) => e.role).toList(), [role]);
      });

      test('should return isJudged effect', () {
        var role = useRole(RoleId.judge).create([Player('test')]);
        var roles = [role];
        var res = calculateMandatoryEffects(roles, 0);

        expect(res.map((e) => e.id).toList(), [EffectId.isJudged]);
        expect(res.map((e) => e.role).toList(), [role]);
      });

      test('should return isMuted effect', () {
        var role = useRole(RoleId.blackWolf).create([Player('test')]);
        var roles = [role];
        var res = calculateMandatoryEffects(roles, 0);

        expect(res.map((e) => e.id).toList(), [EffectId.isMuted]);
        expect(res.map((e) => e.role).toList(), [role]);
      });

      test('should return hasWord effect', () {
        var role = useRole(RoleId.garrulousWolf).create([Player('test')]);
        var roles = [role];
        var res = calculateMandatoryEffects(roles, 0);

        expect(res.map((e) => e.id).toList(), [EffectId.hasWord]);
        expect(res.map((e) => e.role).toList(), [role]);
      });

      test('should return no effect', () {
        var roles = (<RoleId>[
          RoleId.werewolf,
          RoleId.fatherOfWolves,
          RoleId.witch,
          RoleId.witch,
          RoleId.alien,
          RoleId.villager,
          RoleId.wolfpack,
          RoleId.knight,
          RoleId.shepherd,
          RoleId.hunter,
        ]).map((e) => useRole(e).create([Player('test')])).toList();

        var res = calculateMandatoryEffects(roles, 0);

        expect(res, []);
      });

      test('should return expected effects', () {
        var roles = RoleId.values
            .map((e) => useRole(e).create([Player('test')]))
            .toList();

        var res = calculateMandatoryEffects(roles, 0);

        expect(res.map((e) => e.id).toList(), [
          EffectId.isProtected,
          EffectId.isSeen,
          EffectId.shouldTalkFirst,
          EffectId.isJudged,
          EffectId.isMuted,
          EffectId.hasWord,
        ]);
      });
    });

    group('Model', () {
      Game model = Game();

      setUp(() {
        model = Game();
        model.init(createGameList(roles: [
          RoleId.protector,
          RoleId.werewolf,
          RoleId.fatherOfWolves,
          RoleId.blackWolf,
          RoleId.captain,
          RoleId.villager,
          RoleId.seer,
          RoleId.hunter,
        ]));

        model.start();
        model.noContextMode = true;
      });

      group('init()', () {
        test('should initialize model', () {
          var list = createGameList();

          model = Game();
          model.init(list);

          expect(model.state, GameState.initialized);
          expect(model.roles, list);
        });
      });

      group('start()', () {
        test('should start the game', () {
          expect(model.called, []);
          expect(model.available.length, 6);
          expect(model.currentIndex, 0);
        });
      });

      group('next()', () {
        test('should throw when current role is null', () {
          model.currentIndex = -1;

          expect(() => model.next(context), throwsA('currentRole is null.'));
        });

        test('should throw when game state is not GameState.night', () {
          model.state = GameState.day;

          expect(() => model.next(context),
              throwsA('Unexpected game state : ${model.state} .'));
        });

        test('should not skip to next when a mandatory ability is pending', () {
          model.next(context);

          expect(model.called, []);
        });

        test('should switch to next index', () {
          model.currentRole!.abilities[0]
              .use([model.playersList[0]], model.currentTurn);

          model.next(context);

          expect(model.called[0].id, RoleId.protector);
          expect(model.currentRole!.id, RoleId.wolfpack);
          expect(model.called.length, 1);
          expect(model.available.length, 5);
        });

        // TODO : onBeforeCall effect to be called when validation is false;

        test('should switch to day state when all roles are called', () {
          while (model.currentRole != null) {
            if (model.currentRole!.abilities.isNotEmpty) {
              model.currentRole!.abilities[0]
                  .use([model.playersList[0]], model.currentTurn);
            }

            model.next(context);
          }

          expect(model.state, GameState.day);
        });

        test('should call roles again', () {
          model = Game();
          model.init(createGameList(roles: [
            RoleId.protector,
            RoleId.werewolf,
            RoleId.captain,
            RoleId.villager,
            RoleId.seer,
            RoleId.hunter,
            RoleId.witch
          ]));

          model.start();
          model.noContextMode = true;

          var protector = findFirstRoleOfType(model.roles, RoleId.protector)!;
          var wolves = findFirstRoleOfType(model.roles, RoleId.wolfpack)!;
          var seer = findFirstRoleOfType(model.roles, RoleId.seer)!;
          var witch = findFirstRoleOfType(model.roles, RoleId.witch)!;
          var hunter = findFirstRoleOfType(model.roles, RoleId.hunter)!;
          var captain = findFirstRoleOfType(model.roles, RoleId.captain)!;

          // ? protector protects himself
          model.next(context);
          expect(model.currentRole!.id, RoleId.protector);
          protector
              .getAbilityOfType(AbilityId.protect)!
              .use([protector.controller], model.currentTurn);

          // ? wolves kills hunter
          model.next(context);
          expect(model.currentRole!.id, RoleId.wolfpack);
          wolves
              .getAbilityOfType(AbilityId.devour)!
              .use([hunter.controller], model.currentTurn);

          // ? witch skip
          model.next(context);
          expect(model.currentRole!.id, RoleId.witch);

          // ? seer
          model.next(context);
          expect(model.currentRole!.id, RoleId.seer);
          seer
              .getAbilityOfType(AbilityId.clairvoyance)!
              .use([protector.controller], model.currentTurn);

          // ? hunter kills witch
          model.next(context);
          expect(model.currentRole!.id, RoleId.hunter);
          hunter
              .getAbilityOfType(AbilityId.hunt)!
              .use([witch.controller], model.currentTurn);

          // ? captain
          model.next(context);
          expect(model.currentRole!.id, RoleId.captain);
          captain
              .getAbilityOfType(AbilityId.talker)!
              .use([protector.controller], model.currentTurn);

          // ? witch, again
          model.next(context);
          expect(model.state, GameState.night);
          expect(model.currentRole!.id, RoleId.witch);
          witch
              .getAbilityOfType(AbilityId.revive)!
              .use([witch.controller], model.currentTurn);
          witch
              .getAbilityOfType(AbilityId.curse)!
              .use([captain.controller], model.currentTurn);

          // ? captain, again
          model.next(context);
          expect(model.currentRole!.id, RoleId.captain);
          captain
              .getAbilityOfType(AbilityId.inherit)!
              .use([seer.controller], model.currentTurn);

          // * we remove captain,
          // * should happen naturally within the game
          model.roles.remove(captain);
          model.graveyard.add(captain.controller);

          model.next(context);
          expect(model.state, GameState.day);
        });
      });
    });
  });
}

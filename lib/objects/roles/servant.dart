// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

import 'package:werewolves/objects/roles/alien.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/garrulous_wolf.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/werewolf.dart';
import 'package:werewolves/objects/roles/witch.dart';

class Servant extends RoleSingular {
  Servant(super.player) {
    callingPriority = servantPriority;
    abilities = [ServantAbility(this)];
  }

  @override
  RoleId get id {
    return RoleId.servant;
  }

  @override
  bool canUseAbilitiesDuringDay() {
    return false;
  }

  @override
  bool canUseAbilitiesDuringNight() {
    return true;
  }

  @override
  bool canUseSignWithNarrator() {
    return false;
  }

  @override
  List<String> getAdvices(List<Role> roles) {
    return [];
  }

  @override
  List<String> getInformations(List<Role> roles) {
    return [
      'The servant shall choose a target.',
      'If the chosen player dies, the servant takes his role.'
    ];
  }

  @override
  bool shouldBeCalledAtNight(List<Role> roles, int turn) {
    return controller.hasEffect(EffectId.isServing) == false;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

class ServedEffect extends Effect {
  ServedEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isServed;
  }

  @override
  bool get isPermanent {
    return true;
  }
}

class ServingEffect extends Effect {
  ServingEffect(Role source) {
    this.source = source;
  }

  @override
  EffectId get id {
    return EffectId.isServing;
  }

  @override
  bool get isPermanent {
    return true;
  }
}

class ServantAbility extends Ability {
  ServantAbility(Role owner) {
    super.targetCount = 1;
    super.id = AbilityId.serve;
    super.type = AbilityType.active;
    super.useCount = AbilityUseCount.once;
    super.time = AbilityTime.night;
    super.owner = owner;
  }

  @override
  void callOnTarget(Player target) {
    (owner.controller as Player).addEffect(ServingEffect(owner));
    target.addEffect(ServedEffect(owner));
  }

  @override
  bool isTarget(Player target, int turn) {
    return target != owner.controller;
  }

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.controller as Player).hasEffect(EffectId.isServing);
  }

  @override
  bool shouldBeUsedOnDeath() {
    return false;
  }

  @override
  void usePostEffect(Game game, List<Player> affected) {}
}

dynamic calculateNewTeamForServant(Role newRole) {
  /// TODO : if servant is in the lovers team, it should not change its team
  /// TODO : if the new role is a solo role, change it to the new role.

  if (newRole.isWolf) return Team.wolves;

  return false;
}

Role createRoleForServant(Role oldRole, Player servantPlayer) {
  Player dummy = Player('placeholder');
  Role role = Villager(dummy);

  switch (oldRole.id) {
    case RoleId.protector:
      role = Protector(dummy);
      break;
    case RoleId.werewolf:
      role = Werewolf(dummy);
      break;
    case RoleId.fatherOfWolves:
      role = FatherOfWolves(dummy);
      break;
    case RoleId.witch:
      role = Witch(dummy);
      break;
    case RoleId.seer:
      role = Seer(dummy);
      break;
    case RoleId.knight:
      role = Knight(dummy);
      break;
    case RoleId.hunter:
      role = Hunter(dummy);
      break;
    case RoleId.captain:
      role = Captain(dummy);
      break;
    case RoleId.villager:
      role = Villager(dummy);
      break;
    case RoleId.wolfpack:
      role = Werewolf(dummy);
      break;
    case RoleId.servant:
      break;
    case RoleId.judge:
      role = Judge(dummy);
      break;
    case RoleId.blackWolf:
      role = BlackWolf(dummy);
      break;
    case RoleId.garrulousWolf:
      role = GarrulousWolf(dummy);
      break;
    case RoleId.shepherd:
      role = Shepherd(dummy);
      break;
    case RoleId.alien:
      role = Alien(dummy);
      break;
  }

  role.controller = servantPlayer;
  role.callingPriority += 1;

  return role;
}

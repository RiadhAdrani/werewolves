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
    id = RoleId.servant;
    callingPriority = servantCallPriority;
    abilities = [ServantAbility(this)];
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
  List<String> getAdvices(Game game) {
    return [];
  }

  @override
  List<String> getInformations(Game game) {
    return [
      'The servant shall choose a target.',
      'If the chosen player dies, the servant takes his role.'
    ];
  }

  @override
  Team getSupposedInitialTeam() {
    return Team.village;
  }

  @override
  bool shouldBeCalledAtNight(Game game) {
    return player.hasEffect(EffectId.isServing) == false;
  }

  @override
  bool beforeCallEffect(BuildContext context, Game gameModel) {
    return false;
  }
}

class ServeEffect extends Effect {
  ServeEffect(Role source) {
    this.source = source;
    permanent = true;
    type = EffectId.isServed;
  }
}

class ServingEffect extends Effect {
  ServingEffect(Role source) {
    this.source = source;
    permanent = true;
    type = EffectId.isServing;
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
    (owner.player as Player).addEffect(ServingEffect(owner));
    target.addEffect(ServeEffect(owner));
  }

  @override
  bool isTarget(Player target) {
    return target != owner.player;
  }

  @override
  bool isUnskippable() {
    return true;
  }

  @override
  String onAppliedMessage(List<Player> targets) {
    return 'The servant is bound successfully.';
  }

  @override
  bool shouldBeAppliedSurely(Player target) {
    return true;
  }

  @override
  bool shouldBeAvailable() {
    return !(owner.player as Player).hasEffect(EffectId.isServing);
  }

  @override
  bool shouldBeUsedOnOwnerDeath() {
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

  role.player = servantPlayer;
  role.callingPriority += 1;

  return role;
}

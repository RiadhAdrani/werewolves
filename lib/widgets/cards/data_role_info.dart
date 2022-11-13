import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/effect.dart';

Widget gameRoleDataInfo(Role role) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(role.name),
        Text('Playable: ${!role.isObsolete()}'),
        if (role.isGroupRole)
          Text(
              'Team members count : ${(role as RoleGroup).getCurrentPlayers().length}')
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Player name : ${(role.player.getName())}'),
              Text(
                  'Player Status effects : ${(role as RoleSingular).player.effects.map((effect) => effectIdToString(effect.type)).join(' | ')}')
            ],
          )
      ]),
    ),
  );
}

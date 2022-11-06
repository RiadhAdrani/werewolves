import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/widgets/cards/data_info.dart';
import 'package:werewolves/widgets/cards/data_role_info.dart';

void showGameDataDialog(BuildContext context, Game game) {
  List<String> simple = [
    'Number of alive players is ${game.playersList.length}',
    'Number of dead players is ${game.deadPlayers.length}',
    'Number of players within team Village is ${getVillageTeamCount(game.playersList)}',
    'Number of players within team Wolves is ${getWolfTeamCount(game.playersList)}'
  ];

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Current Game Data'),
            content: SizedBox(
              width: 500,
              height: 600,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                          simple.map((info) => gameSimpleData(info)).toList(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Roles',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: game.rolesForDebug
                          .map((role) => gameRoleDataInfo(role))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'))
            ],
          ),
        );
      });
}

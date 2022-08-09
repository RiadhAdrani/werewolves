import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/utils/count_village_team.dart';
import 'package:werewolves/utils/count_wolf_team.dart';
import 'package:werewolves/widgets/cards/data_info.dart';
import 'package:werewolves/widgets/cards/data_role_info.dart';

void showGameDataDialog(BuildContext context, GameModel game) {
  List<String> simple = [
    'Number of alive players is ${game.getPlayersList().length}',
    'Number of dead players is ${game.getDeadPlayers().length}',
    'Number of players within team Village is ${getVillageTeamCount(game.getPlayersList())}',
    'Number of players within team Wolves is ${getWolfTeamCount(game.getPlayersList())}'
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
                      children: game
                          .getRolesForDebug()
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

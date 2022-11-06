import 'package:flutter/material.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/widgets/buttons/standard_text_button.dart';

void showGameOverAlert(Team team, Game game, BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Game over !'),
            content: Text(
              'The ${getTeamName(team)} Team won !',
              textAlign: TextAlign.left,
            ),
            actions: [
              standardTextButton('Leave', () {
                game.dispose();
                Navigator.popUntil(context, ModalRoute.withName("/"));
              }),
            ],
          ),
        );
      });
}

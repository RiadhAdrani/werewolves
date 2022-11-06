import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/widgets/alert/game_data_dialog.dart';
import 'package:werewolves/widgets/alert/game_write_dialog.dart';
import 'package:werewolves/widgets/game/game_leave_dialog.dart';

AppBar gameAppBar(String title, BuildContext context, Game game,
    {Color textColor = Colors.black, Color backgroundColor = Colors.white54}) {
  Widget appBarButton(String text, Function onPress) {
    return TextButton(
        onPressed: () {
          onPress();
        },
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 14),
        ));
  }

  return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 18),
      ),
      actions: [
        appBarButton('Debug', () {
          showGameDataDialog(context, game);
        }),
        appBarButton('Write', () {
          showWriteDialog(context);
        }),
        appBarButton('Leave', () {
          onGameExit(context);
        }),
      ]);
}

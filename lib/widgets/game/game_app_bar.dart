import 'package:flutter/material.dart';
import 'package:werewolves/widgets/game/game_leave_dialog.dart';

AppBar gameAppBar(String title, BuildContext context,
    {
      Color textColor = Colors.black, 
      Color backgroundColor = Colors.white54
      }
  ) {
  return AppBar(
    backgroundColor: backgroundColor,
    automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 18
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              onGameExit(context);
            },
            child: Text(
              'Leave',
              style: TextStyle(
                color: textColor, 
                fontSize: 14
              ),
            )
          )
      ]);
}

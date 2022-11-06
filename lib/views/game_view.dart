import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/widgets/game/game_leave_dialog.dart';

class GameView extends StatefulWidget {
  final GameArguments arguments;

  const GameView(this.arguments, Key? key) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  GameView get widget => super.widget;

  bool _initialized = false;

  void _onBackPressed() {
    onGameExit(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          Provider.of<Game>(context, listen: false).init(widget.arguments.list);
          _initialized = true;
        });
      });
    }

    return Consumer<Game>(builder: (context, value, child) {
      return WillPopScope(
        onWillPop: () async {
          if (!value.hasPendingAbilities) {
            _onBackPressed();
          }

          return false;
        },
        child: Scaffold(body: value.viewToDisplay(context)),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game_arguments.dart';
import 'package:werewolves/models/game_model.dart';

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
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text('Game in progress'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Text('Leave game')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Continure playing'))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          Provider.of<GameModel>(context, listen: false)
              .init(widget.arguments.list);
          _initialized = true;
        });
      });
    }

    return Consumer<GameModel>(builder: (context, value, child) {
      return WillPopScope(
        onWillPop: () async {
          _onBackPressed();
          return false;
        },
        child: Scaffold(body: value.viewToDisplay()),
      );
    });
  }
}

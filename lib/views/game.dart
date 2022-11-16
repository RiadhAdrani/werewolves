import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/utils/utils.dart';

class GameArgumentsExtractor extends StatelessWidget {
  const GameArgumentsExtractor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GameArguments;

    return GamePage(args, const Key('game'));
  }
}

class GamePage extends StatefulWidget {
  final GameArguments arguments;

  const GamePage(this.arguments, Key? key) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  GamePage get widget => super.widget;

  bool initialized = false;

  void _onBackPressed() {
    showExitAlert(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          Provider.of<Game>(context, listen: false).init(widget.arguments.list);
          initialized = true;
        });
      });
    }

    return Consumer<Game>(builder: (context, game, child) {
      return WillPopScope(
        onWillPop: () async {
          if (!game.hasPendingAbilities) {
            _onBackPressed();
          }

          return false;
        },
        child: Scaffold(body: game.useView(context)),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:werewolves/models/game_arguments.dart';
import 'package:werewolves/views/game_view.dart';

class GameArgumentsExtractor extends StatelessWidget {
  const GameArgumentsExtractor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GameArguments;

    return GameView(args, const Key('game'));
  }
}

import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/views/game.dart';

class GameArgumentsExtractor extends StatelessWidget {
  const GameArgumentsExtractor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GameArguments;

    return GamePage(args, const Key('game'));
  }
}

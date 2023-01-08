import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/views/distribute.dart';
import 'package:werewolves/views/game.dart';
import 'package:werewolves/views/home.dart';
import 'package:werewolves/views/select.dart';

class Screen {
  final String path;
  final Widget Function() widget;

  Screen(this.path, this.widget);

  static Screen home = Screen('/', () => const HomePage());
  static Screen select = Screen('/select', () => const SelectionPage());
  static Screen distribute =
      Screen('/distribute', () => const DistributePage());
  static Screen game = Screen('/game', () => const GameArgumentsExtractor());
}

Map<String, Widget Function(BuildContext)> routes = {
  Screen.home.path: (context) => Screen.home.widget(),
  Screen.select.path: (context) => Screen.select.widget(),
  Screen.distribute.path: (context) => Screen.distribute.widget(),
  Screen.game.path: (context) => ChangeNotifierProvider(
        create: (context) => Game(),
        child: Screen.game.widget(),
      )
};

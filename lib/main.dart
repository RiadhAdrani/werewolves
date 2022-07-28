import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/views/distribute_view.dart';
import 'package:werewolves/views/home_view.dart';
import 'package:werewolves/views/select_view.dart';
import 'package:werewolves/widgets/game/game_arguments_extractor.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => SelectedModel(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/select': (context) => const SelectRolesView(),
        '/distribute': (context) => const DistributeView(),
        '/game': (context) => ChangeNotifierProvider(
            create: (context) => GameModel(),
            child: const GameArgumentsExtractor())
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

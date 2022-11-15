import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/views/distribute.dart';
import 'package:werewolves/views/home.dart';
import 'package:werewolves/views/select.dart';
import 'package:werewolves/widgets/game/game_arguments_extractor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
      title: 'Werewolves',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/select': (context) => const SelectionPage(),
        '/distribute': (context) => const DistributePage(),
        '/game': (context) => ChangeNotifierProvider(
            create: (context) => Game(), child: const GameArgumentsExtractor())
      },
    );
  }
}

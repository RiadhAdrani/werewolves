import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/app/theme.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/models/selection.dart';
import 'package:werewolves/app/routing.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => App(),
      child: ChangeNotifierProvider(
        create: (context) => SelectionModel(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      title: t(LKey.appTitle),
      initialRoute: Screen.home.path,
      routes: routes,
    );
  }
}

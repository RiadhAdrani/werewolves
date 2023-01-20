import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/app/routing.dart';
import 'package:werewolves/app/theme.dart';
import 'package:werewolves/i18n/ar.dart';
import 'package:werewolves/i18n/en.dart';
import 'package:werewolves/i18n/fr.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/i18n/locals.dart';
import 'package:werewolves/models/selection.dart';

String t(LK key, {Map<String, dynamic> params = const {}}) {
  String? value;

  switch (App.instance.local) {
    case Localization.en:
      value = en[key];
      break;
    case Localization.fr:
      value = fr[key];
      break;
    case Localization.ar:
      value = ar[key];
      break;
  }

  if (value == null) {
    throw 'Invalid localization key';
  }

  for (var param in params.entries) {
    value = (value as String).replaceAll(
      '{${param.key}}',
      param.value.toString(),
    );
  }

  return value as String;
}

void changeLocalisation(Localization newLocal) {
  App.instance.changeLocalization(newLocal);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      title: t(LK.appTitle),
      initialRoute: Screen.home.path,
      routes: routes,
    );
  }
}

class App extends ChangeNotifier {
  static App instance = App();

  static Widget widget() {
    return ChangeNotifierProvider(
      create: (context) => App(),
      child: ChangeNotifierProvider(
        create: (context) => SelectionModel(),
        child: const MyApp(),
      ),
    );
  }

  App() {
    App.instance = this;
  }

  Localization local = Localization.en;

  void changeLocalization(Localization newLocal) {
    local = newLocal;
    notifyListeners();
  }
}

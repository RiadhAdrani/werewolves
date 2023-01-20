import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werewolves/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(App.widget());
}

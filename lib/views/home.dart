import 'package:flutter/material.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/app/routing.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/widgets/base.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return scaffold(
      appBar: appBar(t(LK.home)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button(
              t(LK.newGame),
              () {
                Navigator.pushNamed(
                  context,
                  Screen.select.path,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

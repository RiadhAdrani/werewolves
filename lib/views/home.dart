import 'package:flutter/material.dart';
import 'package:werewolves/widgets/base.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button('Select roles', () {
              Navigator.pushNamed(context, '/select');
            }),
          ],
        ),
      ),
    );
  }
}

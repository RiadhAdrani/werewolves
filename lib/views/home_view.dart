import 'package:flutter/material.dart';
import 'package:werewolves/widgets/common.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

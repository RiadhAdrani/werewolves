import 'package:flutter/material.dart';
import 'package:werewolves/theme/theme.dart';
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
      backgroundColor: BaseColors.darkJungle,
      appBar: AppBar(
        title: headingTitle(
          'Home',
          color: Colors.white,
          fontFamily: Fonts.almendra,
        ),
        backgroundColor: BaseColors.darkBlue,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/effects/cloth.png'),
              fit: BoxFit.fill,
              opacity: 0.9,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button(
              'Select roles',
              () {
                Navigator.pushNamed(context, '/select');
              },
            ),
          ],
        ),
      ),
    );
  }
}

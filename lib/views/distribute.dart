import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/utils/check_player_name.dart';
import 'package:werewolves/widgets/common.dart';
import 'package:werewolves/widgets/distribute.dart';
import 'package:werewolves/widgets/select.dart';

class DistributePage extends StatefulWidget {
  const DistributePage({Key? key}) : super(key: key);

  @override
  State<DistributePage> createState() => _DistributePageState();
}

class _DistributePageState extends State<DistributePage> {
  bool initialized = false;

  List<Role> initial = [];
  List<Role> picked = [];

  Role? pickedRole;

  void fastCommit() {
    setState(() {
      picked = initial.map((item) {
        var player = Player(item.name);

        player.team = item.getSupposedInitialTeam();

        item.setPlayer(player);

        return item;
      }).toList();

      initial = [];
    });
  }

  void pick(BuildContext context) {
    if (initial.isEmpty) return;

    int index = Random().nextInt(initial.length);

    Role temp = initial[index];

    void commit(String name) {
      setState(() {
        /// We check if the typed parameter T is Player
        /// We should not assign players to Team roles
        /// It is the job of the game model to prepare.
        if (temp.player is Player) {
          var playerToAssign = Player(name);

          playerToAssign.team = temp.getSupposedInitialTeam();

          temp.setPlayer(playerToAssign);
        }

        pickedRole = temp;
        picked = [...picked, pickedRole!];
        initial = initial
            .where((element) => element.instanceId != pickedRole!.instanceId)
            .toList();
      });
    }

    final TextEditingController controller = TextEditingController();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => setPlayerDialog(
              context,
              temp,
              controller,
              () {
                String name = controller.text.trim();

                if (!checkPlayerName(name, picked)) {
                  return;
                }

                commit(name);

                Navigator.pop(context);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          initial =
              Provider.of<SelectedModel>(context, listen: false).generateList();
          initialized = true;
        });
      });
    }

    void reviewAndConfirmList() {
      showDialog(
          context: context,
          builder: (BuildContext builder) {
            return confirmDistributedList(
              context,
              picked,
              () {
                Navigator.pushNamed(context, '/game',
                    arguments: GameArguments(picked));
              },
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distribute Roles'),
      ),
      floatingActionButton:
          fab(initial.isEmpty ? Icons.done : Icons.dangerous_outlined, () {
        if (initial.isNotEmpty) return;
        reviewAndConfirmList();
      }),
      body: inkWell(
        onClick: () => pick(context),
        onHold: fastCommit,
        child: column(
          mainAlignment: MainAxisAlignment.center,
          crossAlignment: CrossAxisAlignment.stretch,
          mainSize: MainAxisSize.max,
          children: [
            column(
              mainAlignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
              children: [
                headingTitle('Click to pick'),
                subTitle('${initial.length} left', weight: FontWeight.normal),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

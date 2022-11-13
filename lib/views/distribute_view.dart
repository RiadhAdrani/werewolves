import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/utils/check_player_name.dart';
import 'package:werewolves/widgets/cards/role_with_name_card.dart';
import 'package:werewolves/widgets/select/select_set_name_dialog.dart';

class DistributeView extends StatefulWidget {
  const DistributeView({Key? key}) : super(key: key);

  @override
  State<DistributeView> createState() => _DistributeViewState();
}

class _DistributeViewState extends State<DistributeView> {
  bool _initialized = false;

  List<Role> _initial = [];
  List<Role> _picked = [];

  Role? _pickedRole;

  void _fastCommitForTesting() {
    setState(() {
      _picked = _initial.map((item) {
        var player = Player(item.name);

        player.team = item.getSupposedInitialTeam();

        item.setPlayer(player);

        return item;
      }).toList();

      _initial = [];
    });
  }

  void _pick(BuildContext context) {
    if (_initial.isEmpty) return;

    int index = Random().nextInt(_initial.length);

    Role temp = _initial[index];

    void commit(String name) {
      setState(() {
        /// We check if the typed paramter T is Player
        /// We should not assign players to Team roles
        /// It is the job of the game model to prepare.
        if (temp.player is Player) {
          var playerToAssign = Player(name);

          playerToAssign.team = temp.getSupposedInitialTeam();

          temp.setPlayer(playerToAssign);
        }

        _pickedRole = temp;
        _picked = [..._picked, _pickedRole!];
        _initial = _initial
            .where((element) => element.instanceId != _pickedRole!.instanceId)
            .toList();
      });
    }

    final TextEditingController controller = TextEditingController();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            setPlayerNameDialog(temp, controller, context, () {
              String name = controller.text.trim();

              if (!checkPlayerName(name, _picked)) {
                return;
              }

              commit(name);

              Navigator.pop(context);
            }, () {
              Navigator.pop(context);
            }));
  }

  AlertDialog confirmDistributedList(
      List<Role> list, Function onConfirm, Function onCancel) {
    return AlertDialog(
      title: Text('Review players list (${list.length})'),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      content: SizedBox(
        width: 350,
        height: 450,
        child: ListView(
          children: list.map((role) {
            return roleWithPlayerName(role, context);
          }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => onConfirm(), child: const Text('Confirm')),
        TextButton(onPressed: () => onCancel(), child: const Text('Cancel'))
      ],
    );
  }

  void reviewAndConfirmList() {
    showDialog(
        context: context,
        builder: (BuildContext builder) => confirmDistributedList(_picked, () {
              Navigator.pushNamed(context, '/game',
                  arguments: GameArguments(_picked));
            }, () {
              Navigator.pop(context);
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _initial =
              Provider.of<SelectedModel>(context, listen: false).generateList();
          _initialized = true;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distribute Roles'),
      ),
      floatingActionButton: _initial.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                reviewAndConfirmList();
              },
              child: const Icon(Icons.done),
            )
          : const Text(''),
      body: InkWell(
        onTap: () {
          _pick(context);
        },
        onLongPress: () {
          _fastCommitForTesting();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Click to pick',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${_initial.length} left',
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

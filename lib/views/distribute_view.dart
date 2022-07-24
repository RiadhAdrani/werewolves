import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/utils/check_player_name.dart';

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

  void _pick(BuildContext context) {
    if (_initial.isEmpty) return;

    int index = Random().nextInt(_initial.length);

    Role temp = _initial[index];

    void commit(name) {
      setState(() {
        if (temp.player is Player){
          temp.player = Player(name);
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
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                temp.getName(),
                style: const TextStyle(fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: 'Enter player name'),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  const Text('No duplicate name allowed',
                      style: TextStyle(fontSize: 14)),
                  const Text('Minimum size is 3',
                      style: TextStyle(fontSize: 14))
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      String name = controller.text.trim();

                      if (!checkPlayerName(name, _picked)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Entered name is invalid.')));
                        return;
                      }

                      commit(name);

                      Navigator.pop(context);
                    },
                    child: const Text('Done')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _initial = Provider.of<SelectedModel>(context, listen: false).items;
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
                print(_picked.map((e) => e.player.name).toString());
              },
              child: const Icon(Icons.done),
            )
          : const Text(''),
      body: InkWell(
        onTap: () {
          _pick(context);
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
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

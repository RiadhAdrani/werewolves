import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/make_available_list.dart';
import 'package:werewolves/widgets/select_role_button_view.dart';

class SelectRoles extends StatefulWidget {
  const SelectRoles({Key? key}) : super(key: key);

  @override
  State<SelectRoles> createState() => _SelectRolesState();
}

class _SelectRolesState extends State<SelectRoles> {
  List<Role> selected = [];
  List<Role> available = [];
  List<Role> items = makeAvailableList();

  void _add(Role role) {
    setState(() {
      selected = [...selected, role];
      available = available
          .where((element) => element.instanceId != role.instanceId)
          .toList();
    });
  }

  void _remove(Role role) {
    setState(() {
      available = [...available, role];
      selected = selected
          .where((element) => element.instanceId != role.instanceId)
          .toList();
    });
  }

  bool _isSelected(Role role) {
    try {
      selected.firstWhere((element) => element.instanceId == role.instanceId);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _toggleSelected(Role role) {
    if (_isSelected(role)) {
      _remove(role);
    } else {
      _add(role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select roles')),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Text'),
                      content: Text('Pick'),
                    );
                  })
            }),
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items
            .map((role) => selectRoleButtonView(role, _isSelected(role), () {
                  _toggleSelected(role);
                }))
            .toList(),
      ),
    );
  }
}

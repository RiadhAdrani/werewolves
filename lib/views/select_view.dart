import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/utils/check_list_is_valid.dart';
import 'package:werewolves/widgets/select/select_role_button_view.dart';

class SelectRolesView extends StatefulWidget {
  const SelectRolesView({Key? key}) : super(key: key);

  @override
  State<SelectRolesView> createState() => _SelectRolesViewState();
}

class _SelectRolesViewState extends State<SelectRolesView> {
  void _next(BuildContext context) {
    List<Role> list = Provider.of<SelectedModel>(context, listen: false).items;

    dynamic result = checkListIsValid(list);

    if (result == true) {
      Navigator.pushNamed(context, '/distribute');
    } else if (result is String) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Oops ! Invalid list !'),
              content: Text(result),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedModel>(
      builder: ((context, selectController, child) {
        return Scaffold(
          appBar: AppBar(
              title: Text('Selected roles (${selectController.items.length})')),
          floatingActionButton: FloatingActionButton(
            onPressed: (() => {_next(context)}),
            child: const Icon(Icons.done),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: selectController.available
                  .map((role) => selectRoleButtonView(
                          role,
                          selectController.isSelected(role),
                          selectController.countNumber(role.id), () {
                        selectController.toggleSelected(role);
                      }, () {
                        if (selectController.countNumber(role.id) > 0 &&
                            role.isUnique == false) {
                          selectController.addCount(role);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added role')));
                        }
                      }))
                  .toList(),
            ),
          ),
        );
      }),
    );
  }
}

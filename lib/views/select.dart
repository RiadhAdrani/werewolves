import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/widgets/common.dart';
import 'package:werewolves/widgets/select.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  void next(BuildContext context) {
    List<Role> list = Provider.of<SelectedModel>(context, listen: false).items;

    dynamic result = useGameStartable(list);

    if (result == true) {
      Navigator.pushNamed(context, '/distribute');
    } else if (result is String) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return dialog(
                title: 'Oops ! Invalid list !',
                iconName: Icons.dangerous_outlined,
                content: paragraph(result),
                actions: [
                  button(
                    'Close',
                    () => Navigator.pop(context),
                    flat: true,
                  ),
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedModel>(
      builder: ((context, selectController, child) {
        return Scaffold(
          appBar: AppBar(
            title: subTitle('Selected roles (${selectController.items.length})',
                color: Colors.white),
          ),
          floatingActionButton: fab(Icons.done, () => next(context)),
          body: padding(
            [8],
            ListView(
              children: selectController.available
                  .map((role) => roleSelectCard(
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

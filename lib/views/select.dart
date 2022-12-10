import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selected_model.dart';
import 'package:werewolves/widgets/base.dart';
import 'package:werewolves/widgets/common.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  void next(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedModel>(
      builder: ((context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: subTitle(
              'Selected roles (${controller.items.length})',
              color: Colors.white,
            ),
          ),
          floatingActionButton: fab(Icons.done, () => next(context)),
          body: decoratedBox(
            color: Colors.black,
            child: padding(
              [16, 8],
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: controller.available.map((role) {
                  int count = controller.getCount(role);
                  bool isUnique = useRole(role).isUnique;

                  void onClick() {
                    if (count == 0) {
                      controller.add(role);
                    } else {
                      controller.remove(role);
                    }
                  }

                  void onHold() {
                    if (isUnique) return;

                    controller.add(role);
                  }

                  return roleCard(
                    role,
                    count: count,
                    greyed: count == 0,
                    onClick: onClick,
                    onHold: onHold,
                  );
                }).toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}

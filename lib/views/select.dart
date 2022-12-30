import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selection.dart';
import 'package:werewolves/app/theme.dart';
import 'package:werewolves/utils/toast.dart';
import 'package:werewolves/utils/utils.dart';
import 'package:werewolves/widgets/base.dart';
import 'package:werewolves/widgets/common.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  void next(List<RoleId> roles) {
    var res = isSelectionValid(roles);

    if (!res.valid) {
      showToast(res.msg!);
    } else {
      Navigator.pushNamed(context, '/distribute');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionModel>(
      builder: ((context, controller, child) {
        return scaffold(
          appBar: appBar(
            'Selected roles (${controller.items.length})',
            showReturnButton: true,
          ),
          fab: fab(
            Icons.done,
            () => next(controller.items),
            color: BaseColors.blond,
            textColor: BaseColors.darkBlue,
          ),
          body: decoratedBox(
            color: BaseColors.darkJungle,
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

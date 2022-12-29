import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/distribution.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/selection.dart';
import 'package:werewolves/theme/theme.dart';
import 'package:werewolves/utils/dialogs.dart';
import 'package:werewolves/utils/toast.dart';
import 'package:werewolves/widgets/base.dart';
import 'package:werewolves/widgets/distribute.dart';

class DistributePage extends StatefulWidget {
  const DistributePage({Key? key}) : super(key: key);

  @override
  State<DistributePage> createState() => _DistributePageState();
}

class _DistributePageState extends State<DistributePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        List<RoleId> roles =
            Provider.of<SelectionModel>(context, listen: false).items;

        return DistributionModel(roles);
      },
      builder: (context, child) {
        return Consumer<DistributionModel>(
          builder: (context, model, child) {
            void pick() {
              int? index = model.pick();

              if (index == null) {
                showToast('All roles are picked !');
                return;
              }

              TextEditingController controller = TextEditingController();

              RoleHelperObject role = useRole(model.roles[index]);

              void assign() {
                bool assigned = model.assign(index, controller.text);

                if (assigned) {
                  dismiss(context)();
                } else {
                  showToast(
                      'Unable to assign role to player ! Name is invalid or already exists !');
                }
              }

              showDialog(
                context: context,
                builder: (context) {
                  return dialog(
                      title: 'Pick a name',
                      content: column(
                        children: [
                          row(
                            crossAlignment: CrossAxisAlignment.center,
                            children: [
                              image(role.icon),
                              padding([0, 0, 0, 12], subTitle(role.name)),
                            ],
                          ),
                          input(controller, placeholder: 'Player name', max: 30)
                        ],
                      ),
                      actions: [
                        button('Done', assign, flat: true),
                        button('Cancel', dismiss(context), flat: true),
                      ]);
                },
              );
            }

            void confirm() {
              if (!model.done) return;

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return confirmDistributedList(context, model.distributed, () {
                    Navigator.pushNamed(
                      context,
                      '/game',
                      arguments: GameArguments(
                        transformRolesFromPickedList(model.distributed),
                      ),
                    );
                  });
                },
              );
            }

            return scaffold(
              appBar: appBar(
                'Distribute',
                showReturnButton: true,
              ),
              fab: !model.done
                  ? null
                  : fab(
                      model.done ? Icons.done : Icons.dangerous_outlined,
                      textColor: Colors.black,
                      confirm,
                    ),
              body: inkWell(
                onClick: pick,
                onHold: model.autofill,
                child: column(
                  mainAlignment: MainAxisAlignment.center,
                  crossAlignment: CrossAxisAlignment.stretch,
                  mainSize: MainAxisSize.max,
                  children: [
                    column(
                      mainAlignment: MainAxisAlignment.center,
                      crossAlignment: CrossAxisAlignment.center,
                      children: [
                        padding(
                          [8],
                          subTitle(
                            'Tap to pick',
                            weight: FontWeight.normal,
                          ),
                        ),
                        padding(
                          [8],
                          subTitle(
                            '${model.picked}/${model.size}',
                            weight: FontWeight.normal,
                          ),
                        ),
                        button(
                          'Reset',
                          model.reset,
                          bgColor: BaseColors.darkBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

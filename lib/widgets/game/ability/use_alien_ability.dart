import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/constants/role_id.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/use_alien_ability_model.dart';
import 'package:werewolves/transformers/strings/get_role_name.dart';
import 'package:werewolves/widgets/buttons/standard_text_button.dart';

void showAlienAbilityDialog(BuildContext context, Ability ability, List<Player> targetList,
    Function(List<Player>) onAbilityUsed, List<Role> remainingRoles,
    {bool cancelable = true}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => UseAlienAbilityModel(targetList, remainingRoles),
          builder: (context, child) {
            final model = context.watch<UseAlienAbilityModel>();

            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text("${ability.getName()} (${ability.owner.getName()})"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Guess the true role(s) of one or more player',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: ListView(
                        children: model.items.map((item) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Checkbox(
                                    value: item.selected,
                                    onChanged: (bool? val) {
                                      model.toggleSelected(item);
                                    }),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.player.getName(),
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    if (item.guess != null)
                                      Text(
                                        'Guess : ${getRoleName(item.guess!)}',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                  ],
                                )),
                                TextButton(
                                    onPressed: () {
                                      _showOptionsForAlienDialog(context, model.possibleGuesses,
                                          (RoleId roleId) {
                                        model.changeGuess(item, roleId);
                                      });
                                    },
                                    child: const Text("Guess"))
                              ]),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                actions: [
                  if (cancelable)
                    standardTextButton('Cancel', () {
                      Navigator.pop(context);
                    }),
                  standardTextButton('Apply', () {
                    dynamic res = model.getCorrectlyGuessedRoles();

                    List<Player> targets = [];

                    if (res == false) {
                      targets.add(ability.owner.player as Player);
                    } else {
                      targets.addAll(res as List<Player>);
                    }

                    onAbilityUsed(targets);
                  }),
                ],
              ),
            );
          },
        );
      });
}

void _showOptionsForAlienDialog(
    BuildContext context, List<RoleId> options, Function(RoleId) onItemSelected) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: ListView(
                    children: options
                        .map((roleId) => Card(
                              child: InkWell(
                                onTap: () {
                                  onItemSelected(roleId);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(getRoleName(roleId)),
                                ),
                              ),
                            ))
                        .toList()),
              )
            ],
          ),
          actions: [
            standardTextButton("Close", () {
              Navigator.pop(context);
            })
          ],
        );
      });
}
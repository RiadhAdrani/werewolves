import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/use_ability_model.dart';
import 'package:werewolves/utils/append_plural_s.dart';
import 'package:werewolves/widgets/alert/game_confirm_ability_use.dart';
import 'package:werewolves/widgets/alert/game_info_alert.dart';
import 'package:werewolves/widgets/buttons/standard_text_button.dart';
import 'package:werewolves/widgets/cards/target_player_card.dart';

void showNormalAbilityDialog(BuildContext context, Ability ability,
    List<Player> targetList, Function onAbilityUsed,
    {bool cancelable = true}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (context) => UseAbilityModel(ability),
          builder: (context, child) {
            final model = context.watch<UseAbilityModel>();

            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text("${ability.name} (${ability.owner.getName()})"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'You have chosen ${model.getSelected().length}/${ability.targetCount} required target${appendPluralS(ability.targetCount)} out of ${targetList.length} possible option${appendPluralS(targetList.length)}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: ListView(
                        children: targetList.map((target) {
                          return targetPlayerCard(
                              target, model.isSelected(target), () {
                            model.toggleSelected(target);
                          });
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
                    final targets = model.getSelected();

                    if (targets.length < ability.targetCount) {
                      showInfoAlert(
                          'Cannot proceed',
                          'You are trying to use an ability without a single selected target while it needs ${ability.targetCount}.',
                          context);
                    } else {
                      showConfirmAlert(
                          'Confirm changes.',
                          'Commiting these changes is irreversable, make sure you selected the correct target.',
                          context, () {
                        onAbilityUsed(targets);
                      });
                    }
                  }),
                ],
              ),
            );
          },
        );
      });
}

import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/use_ability_model.dart';
import 'package:werewolves/models/use_alien_ability_model.dart';
import 'package:werewolves/objects/roles/alien.dart';
import 'package:werewolves/utils/dialogs.dart';
import 'package:werewolves/widgets/common.dart';
import 'package:werewolves/utils/utils.dart';

Widget targetCard(Player player, bool isSelected, Function onClick) {
  return card(
    isSelected: isSelected,
    child: inkWell(
      onClick: () => onClick(),
      child: padding(
        [10, 12, 10, 4],
        row(
          mainSize: MainAxisSize.max,
          mainAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleWithIcon(player.name, Icons.person_outline, size: 14),
            if (isSelected)
              icon(
                Icons.done_outline,
                size: 18,
              ),
          ],
        ),
      ),
    ),
  );
}

Widget abilityDialog(
  UseAbilityModel model,
  BuildContext context,
  Ability ability,
  List<Player> targetList,
  Function(List<Player>) onUsed, {
  bool dismissible = true,
}) {
  void use() {
    final targets = model.getSelected();

    if (targets.length < ability.targetCount) {
      showAlert(
        context,
        'Cannot proceed',
        'You are trying to use an ability without a single selected target while it needs ${ability.targetCount}.',
      );
    } else {
      showConfirm(
        context,
        'Confirm changes.',
        'Committing these changes is irreversible, make sure you selected the correct target.',
        () {
          onUsed(targets);
        },
      );
    }
  }

  void dismiss() {
    Navigator.pop(context);
  }

  return dialog(
      iconName: Icons.explore_outlined,
      title: ability.name,
      content: column(
          mainSize: MainAxisSize.min,
          crossAlignment: CrossAxisAlignment.start,
          children: [
            text(ability.owner.name, color: Colors.black54),
            padding(
              [16, 0],
              paragraph(
                'You have chosen ${model.getSelected().length}/${ability.targetCount} required target${appendPluralS(ability.targetCount)} out of ${targetList.length} possible option${appendPluralS(targetList.length)}',
                italic: true,
              ),
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: ListView(
                children: targetList.map((target) {
                  return targetCard(target, model.isSelected(target), () {
                    model.toggleSelected(target);
                  });
                }).toList(),
              ),
            )
          ]),
      actions: [
        if (dismissible) button('Cancel', dismiss, flat: true),
        button('Apply', use, flat: true)
      ]);
}

Widget alienAbilityDialog(
    BuildContext context,
    UseAlienAbilityModel model,
    Ability ability,
    List<Player> targetList,
    Function(List<Player>) onAbilityUsed,
    List<Role> remainingRoles,
    {bool dismissible = true}) {
  void dismiss() {
    Navigator.pop(context);
  }

  void showOptions(
    AlienGuessItem item,
  ) {
    void onSelected(RoleId option) {
      model.changeGuess(item, option);
      dismiss();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog(
          title: 'Options',
          content: column(
            mainSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: ListView(
                  children: model.possibleGuesses
                      .map(
                        (option) => card(
                          child: inkWell(
                            onClick: () {
                              onSelected(option);
                            },
                            child: padding(
                              [8],
                              text(
                                getRoleName(option),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void apply() {
    dynamic res = Alien.getCorrectlyGuessedRoles(model.items);

    List<Player> targets = [];

    if (res == false) {
      targets.add(ability.owner.player as Player);
    } else {
      targets.addAll(res as List<Player>);
    }

    onAbilityUsed(targets);
  }

  Widget roleToGuessCard(
    AlienGuessItem item,
    Function(AlienGuessItem) onCheckChange,
    Function onItemPressed,
  ) {
    return card(
      child: padding(
        [4],
        row(
          crossAlignment: CrossAxisAlignment.center,
          children: [
            checkbox(
              item.selected,
              (bool? val) {
                onCheckChange(item);
              },
            ),
            Expanded(
                child: column(
              crossAlignment: CrossAxisAlignment.start,
              children: [
                text(item.player.name),
                if (item.guess != null)
                  paragraph('Guess : ${getRoleName(item.guess!)}'),
              ],
            )),
            TextButton(
                onPressed: () {
                  onItemPressed();
                },
                child: const Text("Guess"))
          ],
        ),
      ),
    );
  }

  return dialog(
      title: "${ability.name} (${ability.owner.name})",
      content: column(
          mainSize: MainAxisSize.min,
          crossAlignment: CrossAxisAlignment.start,
          children: [
            padding(
              [16, 0],
              text('Guess the true role(s) of one or more player'),
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: ListView(
                children: model.items.map((item) {
                  return roleToGuessCard(
                    item,
                    (item) => model.toggleSelected(item),
                    () {
                      showOptions(item);
                    },
                  );
                }).toList(),
              ),
            )
          ]),
      actions: [
        if (dismissible) button('Cancel', dismiss, flat: true),
        button('Apply', apply, flat: true)
      ]);
}

import 'package:flutter/material.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/app/theme.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/models/use_ability_model.dart';
import 'package:werewolves/models/use_alien_ability_model.dart';
import 'package:werewolves/objects/roles/alien.dart';
import 'package:werewolves/utils/dialogs.dart';
import 'package:werewolves/widgets/base.dart';
import 'package:werewolves/utils/utils.dart';

Widget targetCard(
  Player player,
  bool isSelected,
  Function onClick,
) {
  return card(
    isSelected: isSelected,
    selectedBgColor: BaseColors.red,
    child: inkWell(
      onClick: () => onClick(),
      child: padding(
        [10, 12, 10, 4],
        row(
          mainSize: MainAxisSize.max,
          mainAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleWithIcon(
              ellipsify(player.name, 20),
              Icons.person_outline,
              size: 14,
            ),
            if (isSelected)
              icon(
                Icons.done,
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
        t(LKey.gameConfirmUseIssueTitle),
        t(LKey.gameConfirmUseIssueText, params: {'count': ability.targetCount}),
      );
    } else {
      showConfirm(
        context,
        t(LKey.gameConfirmUseDoneTitle),
        t(LKey.gameConfirmUseDoneText),
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
            text(
              ability.description,
            ),
            padding(
              [16, 0],
              paragraph(
                t(LKey.gameAbilityDialogParagraph, params: {
                  'count': model.getSelected().length,
                  'needed': ability.targetCount,
                  'targetCount': targetList.length,
                }),
              ),
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: ListView(
                children: targetList.map((target) {
                  void onClick() {
                    model.toggleSelected(target);
                  }

                  return targetCard(
                    target,
                    model.isSelected(target),
                    onClick,
                  );
                }).toList(),
              ),
            )
          ]),
      actions: [
        if (dismissible) button(t(LKey.cancel), dismiss, flat: true),
        button(t(LKey.done), use, flat: true)
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
          title: t(LKey.options),
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
                  paragraph(
                    t(LKey.gameAbilityGuessCurrentTry, params: {
                      'guess': getRoleName(item.guess!),
                    }),
                  ),
              ],
            )),
            TextButton(
                onPressed: () {
                  onItemPressed();
                },
                child: text(t(LKey.guess)))
          ],
        ),
      ),
    );
  }

  return dialog(
      title: t(LKey.gameAbilityGuessTitle, params: {
        'ability': ability.name,
        'role': ability.owner.name,
      }),
      content: column(
          mainSize: MainAxisSize.min,
          crossAlignment: CrossAxisAlignment.start,
          children: [
            padding(
              [16, 0],
              text(t(LKey.gameAbilityGuessText)),
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
        if (dismissible) button(t(LKey.cancel), dismiss, flat: true),
        button(t(LKey.done), apply, flat: true)
      ]);
}

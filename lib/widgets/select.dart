import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/widgets/base.dart';

Widget roleSelectCard(
    Role role, bool isSelected, count, onPressed, onLongPress) {
  return card(
    isSelected: isSelected,
    child: inkWell(
        onClick: () => onPressed(),
        onHold: () => onLongPress(),
        child: padding(
          [12],
          row(
            children: [
              padding(
                [8],
                Image.asset(role.icon),
              ),
              flexible(
                padding(
                  [0, 8],
                  column(
                    crossAlignment: CrossAxisAlignment.start,
                    children: [
                      padding([4, 0], subTitle('${role.name} (x$count)')),
                      padding(
                          [4, 0],
                          text(role.isUnique ? 'Super role' : 'Normal role',
                              italic: true)),
                      paragraph(role.description),
                    ],
                  ),
                ),
              ),
              icon(Icons.check_rounded,
                  color: isSelected ? Colors.black : Colors.white),
            ],
          ),
        )),
  );
}

Widget setPlayerDialog(
  BuildContext context,
  Role temp,
  TextEditingController controller,
  Function onDone,
) {
  return dialog(
    context: context,
    iconName: Icons.person,
    title: temp.name,
    content: column(
      mainSize: MainAxisSize.min,
      crossAlignment: CrossAxisAlignment.start,
      children: [
        input(
          controller,
          max: 25,
          placeholder: 'Enter player name',
          capitalization: TextCapitalization.words,
        ),
        // TODO : refactor into a widget
        SingleChildScrollView(
          child: column(
            crossAlignment: CrossAxisAlignment.start,
            children: [
              paragraph('• No duplicate name allowed'),
              paragraph('• Minimum size is 3'),
              paragraph('• No duplicate name allowed'),
            ],
          ),
        )
      ],
    ),
    actions: [
      button('Done', onDone, flat: true),
    ],
  );
}

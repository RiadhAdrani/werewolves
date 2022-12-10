import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/widgets/base.dart';

Widget confirmDistributedList(
  BuildContext context,
  List<Role> list,
  Function onConfirm,
) {
  return dialog(
    context: context,
    title: 'Review players list (${list.length})',
    content: SizedBox(
      width: 350,
      height: 450,
      child: ListView(
        children: list.map((role) {
          return card(
              child: padding(
                  [8],
                  column(children: [
                    text(
                      role.player.name,
                      weight: FontWeight.bold,
                      italic: true,
                    ),
                    paragraph(role.name),
                  ])));
        }).toList(),
      ),
    ),
    actions: [
      button('Confirm', () => onConfirm(), flat: true),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/models/distribution.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/utils.dart';
import 'package:werewolves/widgets/base.dart';

Widget confirmDistributedList(
  BuildContext context,
  List<DistributedRole> list,
  Function onConfirm,
) {
  return dialog(
    context: context,
    title: t(LK.distributeReview, params: {'count': list.length}),
    content: SizedBox(
      width: 350,
      height: 450,
      child: ListView(
        children: list.map((role) {
          return card(
            child: padding(
              [8],
              row(
                children: [
                  image(useRole(role.id).icon),
                  padding(
                    [8],
                    column(
                      children: [
                        text(
                          ellipsify(role.player, 20),
                          overflow: false,
                          weight: FontWeight.bold,
                          italic: true,
                        ),
                        text(
                          useRole(role.id).name,
                          size: 10,
                          italic: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
    actions: [
      button('Confirm', () => onConfirm(), flat: true),
    ],
  );
}

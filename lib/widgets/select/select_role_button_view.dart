import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/widgets/common.dart';

Widget selectRoleButtonView(
    Role role, bool isSelected, count, onPressed, onLongPress) {
  return card(
    isSelected: isSelected,
    child: InkWell(
        onTap: () => onPressed(),
        onLongPress: () => onLongPress(),
        child: padding(
          [12],
          Row(
            children: [
              padding(
                [8],
                Image.asset(role.icon),
              ),
              Flexible(
                child: padding(
                  [0, 8],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
              Icon(
                Icons.check_rounded,
                color: isSelected ? Colors.black : Colors.white,
              )
            ],
          ),
        )),
  );
}

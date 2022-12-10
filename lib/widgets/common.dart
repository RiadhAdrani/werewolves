import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/widgets/base.dart';

Widget roleCard(
  RoleId id, {
  int count = 0,
  bool greyed = false,
  void Function()? onClick,
  void Function()? onHold,
}) {
  var use = useRole(id);

  String name = use.name;
  String icon = use.icon;

  return decoratedBox(
      radius: [6],
      img: icon,
      blendMode: greyed ? BlendMode.saturation : null,
      blendColor: greyed ? Colors.grey : null,
      child: inkWell(
        onClick: onClick,
        onHold: onHold,
        child: column(crossAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            width: double.infinity,
            child: row(
              mainAlignment: MainAxisAlignment.end,
              children: [
                decoratedBox(
                  color: Colors.black.withOpacity(0.75),
                  radius: [0, 6, 0, 6],
                  child: padding(
                    [2, 6],
                    text(
                      count.toString(),
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: text('')),
          SizedBox(
            width: double.infinity,
            child: decoratedBox(
                radius: [0, 6],
                color: Colors.black.withOpacity(0.75),
                child: padding(
                  [8, 0],
                  text(
                    name,
                    center: true,
                    color: Colors.white,
                    size: 10,
                  ),
                )),
          )
        ]),
      ));
}

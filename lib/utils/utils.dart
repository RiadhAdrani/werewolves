import 'package:flutter/material.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/widgets/common.dart';
import 'package:werewolves/widgets/game.dart';

void showExitAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: ((context) => confirmQuitDialog(context)),
  );
}

void showAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => alert(context, title, message),
  );
}

void showConfirm(
    BuildContext context, String title, String message, Function onConfirm) {
  showDialog(
      context: context,
      builder: (context) => confirm(
            context,
            title,
            message,
            onConfirm,
          ));
}

void showConfirmUse(BuildContext context, String message, Function onConfirm) {
  showConfirm(context, 'Confirm ability use', message, onConfirm);
}

Function dismiss(BuildContext context) {
  return () => Navigator.pop(context);
}

bool checkPlayerName(String name, List<Role> list) {
  if (name.trim().isEmpty) return false;

  if (name.trim().length < 3) return false;

  RegExp validator = RegExp(r'^[a-zA-Z0-9 ]+$');

  if (!validator.hasMatch(name)) {
    return false;
  }

  for (var i = 0; i < list.length; i++) {
    if (list[i].player is Player &&
        list[i].player.id.toString().trim().toLowerCase() ==
            name.trim().toLowerCase()) {
      return false;
    }
  }

  return true;
}

String appendPluralS(int number) {
  return number > 1 ? 's' : '';
}

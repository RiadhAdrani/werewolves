import 'package:flutter/material.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/widgets/base.dart';
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
  showConfirm(context, t(LK.gameConfirmUse), message, onConfirm);
}

Function dismiss(BuildContext context) {
  return () => Navigator.pop(context);
}

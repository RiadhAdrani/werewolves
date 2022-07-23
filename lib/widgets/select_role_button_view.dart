import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

TextButton selectRoleButtonView(Role role, bool isSelected, onPressed) {
  return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(role.getName()),
          isSelected ? const Icon(Icons.check_rounded) : const Text('')
        ],
      ));
}

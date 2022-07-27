import 'package:flutter/material.dart';
import 'package:werewolves/models/player.dart';

Widget targetPlayerCard(
  Player player, 
  bool isSelected,
  Function onTap
) {

  return Card(
    child: InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal :8.0, 
          vertical: 12
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              player.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
            if (isSelected) const Icon(Icons.donut_large_sharp,size: 20,)
          ]
        ),
      ),
    ),
  );
}

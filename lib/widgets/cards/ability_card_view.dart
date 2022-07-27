import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';

Widget abilityCardView(Ability ability, Function onClick) {
  String shouldBeUsed = ability.isUnskippable()
      ? "Mandatory"
      : "Optional";
  Color shouldBeUsedColor = ability.isUnskippable()
      ? Colors.red
      : Colors.black;

  return Card(
    child: InkWell(
      onTap: () {
        onClick();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ability.getName(),
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                shouldBeUsed,
                style: TextStyle(
                    fontSize: 14, 
                    color: shouldBeUsedColor
                ),
              ),
            ),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia molestie ex sit amet eleifend. Nullam sit amet diam est. Quisque rhoncus nisl non lobortis interdum.",
              style: TextStyle(
                fontSize: 14, 
                fontStyle: FontStyle.italic
              ),
            )
          ],
        ),
      ),
    ),
  );
}

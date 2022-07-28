import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';

Widget abilityCardView(Ability ability, Function onClick) {
  bool should = ability.isUnskippable();
  String skipText = ability.isUnskippable()
      ? "This ability should be used."
      : "Optional";
  Color skipColor = ability.isUnskippable()
      ? Colors.red
      : Colors.black;

  return Card(
    margin: const EdgeInsets.all(4),
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
                  fontSize: 20,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.blueGrey[200],),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    should ? Icons.dangerous_outlined : Icons.done, 
                    size: 20,
                    color: skipColor,
                  ),
                  Text(
                    skipText,
                    style: TextStyle(
                        fontSize: 14, 
                        color: skipColor
                    ),
                  ),
                ],
              ),
            ),
            Text(
              ability.getDescription(),
              style: TextStyle(
                fontSize: 13, 
                fontStyle: FontStyle.italic,
                color: Colors.blueGrey[700]
              ),
            )
          ],
        ),
      ),
    ),
  );
}

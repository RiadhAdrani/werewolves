import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';

Widget abilityCardView(Ability ability, Function onClick,
    {bool variant = false}) {
  bool should = ability.isUnskippable();
  String skipText =
      ability.isUnskippable() ? "This ability should be used." : "Optional";
  Color skipColor = ability.isUnskippable() ? Colors.red : Colors.black;

  Widget content = Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ability.name,
          style: TextStyle(
              fontSize: variant ? 16 : 20,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold),
        ),
        if (variant)
          Text(
            ability.owner.getPlayerName(),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
            ),
          ),
        Divider(
          color: Colors.blueGrey[200],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                should ? Icons.dangerous_outlined : Icons.done,
                size: variant ? 14 : 20,
                color: skipColor,
              ),
              Text(
                skipText,
                style: TextStyle(fontSize: variant ? 12 : 14, color: skipColor),
              ),
            ],
          ),
        ),
        Text(
          ability.description,
          style: TextStyle(
              fontSize: variant ? 11 : 13,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey[700]),
        )
      ],
    ),
  );

  return Card(
    margin: const EdgeInsets.all(4),
    child: InkWell(
        onTap: () {
          onClick();
        },
        child: content),
  );
}

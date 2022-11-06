import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/widgets/text/title_with_icon.dart';

Widget dayInfoSectionView(Game game) {
  final list =
      game.getCurrentTurnSummary().map((item) => item.getText()).toList();

  return ExpansionTile(
    initiallyExpanded: true,
    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
    title: titleWithIcon('Happened last night', Icons.list_alt_outlined,
        alignment: MainAxisAlignment.start),
    children: list
        .map((item) => Card(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                item,
                textAlign: TextAlign.left,
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            )))
        .toList(),
  );
}

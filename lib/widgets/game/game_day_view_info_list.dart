import 'package:flutter/material.dart';
import 'package:werewolves/models/game_model.dart';
import 'package:werewolves/widgets/text/title_with_icon.dart';

Widget endOfNightinforListView(GameModel game) {
  final list =
      game.getEndOfNightSummary().map((item) => item.getText()).toList();

  return Flexible(
    child: Column(
      children: [
        titleWithIcon('Last night...', Icons.announcement_outlined),
        Expanded(
            child: ListView.builder(
          itemCount: list.length,
          itemBuilder: ((context, index) {
            return Card(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(list[index],style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),),
            ));
          }),
        ))
      ],
    ),
  );
}

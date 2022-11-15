import 'package:flutter/material.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/widgets/alert/game_data_dialog.dart';
import 'package:werewolves/widgets/alert/game_write_dialog.dart';
import 'package:werewolves/widgets/cards/ability_card_view.dart';
import 'package:werewolves/widgets/common.dart';
import 'package:werewolves/widgets/game/game_leave_dialog.dart';

Widget gamePreView(Game game, BuildContext context) {
  return Center(
    child: padding(
      [8],
      column(
        crossAlignment: CrossAxisAlignment.center,
        mainAlignment: MainAxisAlignment.center,
        children: [
          padding([8], title('Everything is ready !')),
          divider(),
          button('Start', () => game.startTurn(), flat: true),
        ],
      ),
    ),
  );
}

AppBar gameBar(
  BuildContext context,
  String title,
  Game game, {
  Color? bgColor,
  Color txtColor = Colors.white,
}) {
  return appBar(
    title,
    bgColor: bgColor,
    txtColor: txtColor,
    actions: [
      AppBarButton('Debug', () => showGameDataDialog(context, game)),
      AppBarButton('Write', () => showWriteDialog(context)),
      AppBarButton('Leave', () => onGameExit(context)),
    ],
  );
}

Widget gameNightViewHeading(Role role) {
  return padding(
    [8, 0],
    column(crossAlignment: CrossAxisAlignment.center, children: [
      image(
        role.icon,
        width: 75,
        height: 75,
      ),
      padding(
        [4],
        headingTitle(role.name),
      ),
      padding(
        [4],
        text(
          '(${role.getPlayerName()})',
          italic: true,
          weight: FontWeight.normal,
        ),
      ),
    ]),
  );
}

Widget gameNightViewInfos(List<String> infoList) {
  return padding(
    [8, 0],
    column(
      crossAlignment: CrossAxisAlignment.center,
      children: [
        padding(
            [0, 0, 4, 0],
            titleWithIcon(
              'Important informations',
              Icons.announcement_outlined,
            )),
        column(
          crossAlignment: CrossAxisAlignment.stretch,
          children: infoList.map((txt) {
            return card(
              child: padding([4], paragraph(txt, center: true)),
            );
          }).toList(),
        )
      ],
    ),
  );
}

Widget gameNightViewAbilities(Game game, BuildContext context) {
  final abilities = game.currentRole!.abilities
      .where((ability) => game.isAbilityAvailableAtNight(ability))
      .toList();

  return Flexible(
      flex: 1,
      child: padding(
        [8, 0],
        column(
          mainAlignment: MainAxisAlignment.center,
          crossAlignment: CrossAxisAlignment.stretch,
          children: [
            titleWithIcon(
              'Remaining abilities',
              Icons.list_alt_outlined,
              alignment: MainAxisAlignment.center,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: abilities.length,
                itemBuilder: (context, index) {
                  final ability = abilities[index];

                  return abilityCardView(ability, () {
                    game.showUseAbilityDialog(
                      context,
                      ability,
                      (List<Player> targets) {
                        game.useAbilityInNight(ability, targets, context);
                      },
                    );
                  });
                },
              ),
            )
          ],
        ),
      ));
}

Widget gameNightView(Game game, BuildContext context) {
  return Scaffold(
    appBar: gameBar(
      context,
      'Night (${game.currentTurn})',
      game,
    ),
    body: padding(
      [8],
      column(
        crossAlignment: CrossAxisAlignment.stretch,
        mainAlignment: MainAxisAlignment.start,
        children: [
          gameNightViewHeading(game.currentRole!),
          divider(),
          gameNightViewInfos(game.currentRole!.getInformations(game)),
          divider(),
          gameNightViewAbilities(game, context),
          button(
            'Next',
            () => game.next(context),
            flat: true,
          ),
        ],
      ),
    ),
  );
}

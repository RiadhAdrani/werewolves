import 'package:flutter/material.dart';
import 'package:werewolves/constants/game_advices.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/utils.dart';
import 'package:werewolves/widgets/alert/game_confirm_ability_use.dart';
import 'package:werewolves/widgets/alert/game_data_dialog.dart';
import 'package:werewolves/widgets/alert/game_write_dialog.dart';
import 'package:werewolves/widgets/cards/ability_card_view.dart';
import 'package:werewolves/widgets/common.dart';

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
      AppBarButton('Leave', () => showExitAlert(context)),
    ],
  );
}

Widget gameNightViewHeading(Role role) {
  return padding(
    [8, 0],
    column(
        crossAlignment: CrossAxisAlignment.center,
        mainAlignment: MainAxisAlignment.center,
        children: [
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
              center: true,
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

Widget guideSection(
  String title,
  IconData icon,
  List<String> list, {
  bool expanded = false,
}) {
  return ExpansionTile(
    initiallyExpanded: expanded,
    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
    backgroundColor: Colors.grey[350],
    title: titleWithIcon(title, icon, alignment: MainAxisAlignment.start),
    children: list
        .map(
          (item) => card(
            child: padding(
              [8],
              paragraph(item),
            ),
          ),
        )
        .toList(),
  );
}

Widget gameDayGuide(
  List<String> nightInfos,
  List<String> dayInfos,
  List<String> alivePlayers,
  List<String> deadPlayers,
) {
  return SingleChildScrollView(
    child: padding(
      [8],
      column(children: [
        guideSection(
          'Night events',
          Icons.nightlight_outlined,
          nightInfos,
          expanded: true,
        ),
        guideSection(
          'Day events',
          Icons.wb_sunny_outlined,
          dayInfos,
        ),
        guideSection(
          'Alive Players',
          Icons.group_outlined,
          alivePlayers,
        ),
        guideSection(
          'Dead Players',
          Icons.no_accounts_outlined,
          deadPlayers,
        ),
        guideSection(
          'Phase 1 : Discussion',
          Icons.message_outlined,
          discussionSteps,
        ),
        guideSection(
          'Phase 2 : Vote',
          Icons.how_to_vote_outlined,
          voteSteps,
        ),
        guideSection(
          'Phase 3 : Defense',
          Icons.shield_outlined,
          defenseSteps,
        ),
        guideSection(
          'Phase 4 : Execution',
          Icons.cancel_outlined,
          executionSteps,
        ),
      ]),
    ),
  );
}

Widget gameDayView(Game game, BuildContext context) {
  List<String> nightInfos =
      game.getCurrentTurnSummary().map((info) => info.getText()).toList();

  List<String> dayInfos =
      game.getCurrentDaySummary().map((info) => info.getText()).toList();

  List<String> alivePlayers = game.playersList
      .map((player) => '${player.name} (as ${player.mainRole.name})')
      .toList();

  List<String> deadPlayers =
      game.deadPlayers.map((player) => player.name).toList();

  void startNight() {
    showConfirmAlert(
        'Start night phase',
        'You are about to start the night phase, are you sure you completed all the steps ?',
        context, () {
      game.startTurn();
    });
  }

  return Scaffold(
    appBar: gameBar(
      context,
      'Day (${game.currentTurn})',
      game,
    ),
    body: padding(
      [0],
      column(
        crossAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: Colors.grey[300]!,
            child: padding(
              [8],
              titleWithIcon(
                'Guide',
                Icons.help,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: gameDayGuide(
              nightInfos,
              dayInfos,
              alivePlayers,
              deadPlayers,
            ),
          ),
          ColoredBox(
            color: Colors.grey[300]!,
            child: padding(
              [8],
              titleWithIcon('Usable abilities', Icons.subject_rounded),
            ),
          ),
          Flexible(
            flex: 1,
            child: padding(
              [8],
              ListView(
                scrollDirection: Axis.vertical,
                children: game.getDayAbilities().map((Ability ability) {
                  return abilityCardView(ability, () {
                    showConfirmAlert(
                      'Before using the ability',
                      'Make sure everyone else is asleep.',
                      context,
                      () {
                        game.showUseAbilityDialog(
                          context,
                          ability,
                          (List<Player> targets) {
                            game.useAbilityInDay(ability, targets, context);
                          },
                        );
                      },
                    );
                  }, variant: true);
                }).toList(),
              ),
            ),
          ),
          button("Start night", startNight, flat: true)
        ],
      ),
    ),
  );
}

Widget confirmQuitDialog(BuildContext context) {
  return confirm(
    context,
    'Game in progress',
    'Are you sure you want to quit the game?',
    () {
      Navigator.popUntil(context, ModalRoute.withName("/"));
    },
  );
}

Widget appliedDialog(BuildContext context, String message) {
  return confirm(
    context,
    'Ability used',
    message,
    dismiss(context),
  );
}

import 'package:flutter/material.dart';
import 'package:werewolves/constants/game_advices.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/dialogs.dart';
import 'package:werewolves/widgets/common.dart';
import 'package:werewolves/models/effect.dart';

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
  void showDebug() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => debugDialog(context, game));
  }

  void showWrite() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => writeDialog(context));
  }

  void showExit() {
    showExitAlert(context);
  }

  return appBar(
    title,
    bgColor: bgColor,
    txtColor: txtColor,
    actions: [
      AppBarButton('Debug', showDebug),
      AppBarButton('Write', showWrite),
      AppBarButton('Leave', showExit),
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
            padding(
              [0, 0, 8, 0],
              titleWithIcon(
                'Remaining abilities',
                Icons.list_alt_outlined,
                alignment: MainAxisAlignment.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: abilities.length,
                itemBuilder: (context, index) {
                  final ability = abilities[index];

                  return abilityCard(
                    ability,
                    () {
                      game.showUseAbilityDialog(
                        context,
                        ability,
                        (List<Player> targets) {
                          dismiss(context)();

                          game.useAbilityInNight(ability, targets, context);
                        },
                      );
                    },
                  );
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
          gameNightViewInfos(
            game.currentRole!.getInformations(game.playableRoles),
          ),
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
    showConfirm(
      context,
      'End of day',
      'You are about to start the night phase, are you sure you completed all the steps ?',
      () {
        dismiss(context)();
        game.startTurn();
      },
    );
  }

  void onAbilityClicked(Ability ability) {
    showConfirm(
      context,
      'Before using the ability',
      'Make sure everyone else is asleep.',
      () {
        dismiss(context)();
        game.showUseAbilityDialog(
          context,
          ability,
          (List<Player> targets) {
            dismiss(context)();
            game.useAbilityInDay(ability, targets, context);
          },
        );
      },
    );
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
                  return abilityCard(
                    ability,
                    () => onAbilityClicked(ability),
                    variant: true,
                  );
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

Widget debugDialog(BuildContext context, Game game) {
  List<String> simple = [
    'Alive : ${game.playersList.length}',
    'Dead : ${game.deadPlayers.length}',
    'Villagers : ${useVillagersCounter(game.playersList)}',
    'Werewolves : ${useWolvesCounter(game.playersList)}',
    'Solos : ${useSolosCounter(game.playersList)}'
  ];

  Widget dataView(String data, {IconData icon = Icons.info_outline}) {
    return card(
      child: padding(
        [8],
        titleWithIcon(
          data,
          icon,
          color: Colors.black45,
          alignment: MainAxisAlignment.start,
        ),
      ),
    );
  }

  Widget roleDebugView(Role role) {
    return card(
      child: padding(
        [8],
        column(crossAlignment: CrossAxisAlignment.start, children: [
          text(role.name, weight: FontWeight.w500),
          divider(),
          titleWithIcon(
            role.isObsolete() ? 'Obsolete' : 'Playing',
            role.isObsolete() ? Icons.error_outline : Icons.done,
            alignment: MainAxisAlignment.start,
            color: Colors.black45,
          ),
          divider(),
          if (role.isGroupRole)
            titleWithIcon(
              '${(role as RoleGroup).getCurrentPlayers().length}',
              Icons.people_outline,
              alignment: MainAxisAlignment.start,
              color: Colors.black45,
            )
          else
            column(
              crossAlignment: CrossAxisAlignment.stretch,
              children: [
                titleWithIcon(
                  (role.player as Player).name,
                  Icons.person_outline,
                  alignment: MainAxisAlignment.start,
                  color: Colors.black45,
                ),
                if ((role as RoleSingular).player.effects.isNotEmpty)
                  titleWithIcon(
                    role.player.effects
                        .map((effect) => effectIdToString(effect.type))
                        .join(' | '),
                    Icons.adjust_sharp,
                    alignment: MainAxisAlignment.start,
                    color: Colors.black45,
                  ),
              ],
            )
        ]),
      ),
    );
  }

  return dialog(
    context: context,
    iconName: Icons.list_alt,
    title: 'Debug infos',
    dismissible: false,
    content: SizedBox(
      width: 500,
      height: 600,
      child: SingleChildScrollView(
        child: column(
          crossAlignment: CrossAxisAlignment.stretch,
          children: [
            padding(
              [8, 0],
              subTitle('Stats'),
            ),
            column(
              crossAlignment: CrossAxisAlignment.stretch,
              children: simple.map((info) => dataView(info)).toList(),
            ),
            divider(),
            padding(
              [8, 0],
              subTitle('Roles'),
            ),
            column(
              crossAlignment: CrossAxisAlignment.stretch,
              children: game.rolesForDebug
                  .map((role) => roleDebugView(role))
                  .toList(),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget writeDialog(BuildContext context) {
  return dialog(
    context: context,
    iconName: Icons.message,
    title: 'Write',
    dismissible: false,
    content: SizedBox(
      width: 400,
      child: column(
        mainSize: MainAxisSize.min,
        children: [
          paragraph(
              'You can write something here and show it to the player in case there is some problems.'),
          const TextField(
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget abilityCard(Ability ability, Function onClick, {bool variant = false}) {
  bool should = ability.isUnskippable();
  String skipText =
      ability.isUnskippable() ? "This ability should be used." : "Optional";
  Color skipColor = ability.isUnskippable() ? Colors.red : Colors.black;

  Widget content = padding(
    [12],
    column(
      crossAlignment: CrossAxisAlignment.start,
      children: [
        text(
          ability.name,
          size: variant ? 14 : 18,
          weight: FontWeight.w500,
        ),
        if (variant)
          text(
            ability.owner.getPlayerName(),
            size: 12,
          ),
        divider(),
        padding(
          [4, 0],
          row(
            children: [
              icon(
                should ? Icons.dangerous_outlined : Icons.done,
                size: variant ? 14 : 20,
                color: skipColor,
              ),
              text(
                skipText,
                color: skipColor,
                size: variant ? 10 : 12,
                italic: should,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  return padding(
    [4],
    card(
      child: inkWell(
        onClick: () => onClick(),
        child: content,
      ),
    ),
  );
}

Widget stepAlert(String title, String text, List<String> items,
    BuildContext context, Function onNext) {
  return dialog(
      iconName: Icons.next_plan_outlined,
      title: title,
      dismissible: false,
      content: column(
        children: [
          paragraph(text),
        ],
      ),
      actions: [
        button(
          'Done',
          () {
            dismiss(context)();
            onNext();
          },
          flat: true,
        ),
      ]);
}

import 'package:flutter/material.dart';
import 'package:werewolves/app/app.dart';
import 'package:werewolves/app/routing.dart';
import 'package:werewolves/app/theme.dart';
import 'package:werewolves/constants/game_advices.dart';
import 'package:werewolves/i18n/keys.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/utils/dialogs.dart';
import 'package:werewolves/utils/utils.dart';
import 'package:werewolves/widgets/base.dart';
import 'package:werewolves/models/effect.dart';

Widget gamePreView(Game game, BuildContext context) {
  return Center(
    child: padding(
      [8],
      column(
        crossAlignment: CrossAxisAlignment.center,
        mainAlignment: MainAxisAlignment.center,
        children: [
          padding([8], title(t(LKey.gameReady))),
          divider(),
          button(t(LKey.start), game.start, flat: true),
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
      AppBarButton(t(LKey.gameDebug), showDebug),
      AppBarButton(t(LKey.gameWrite), showWrite),
      AppBarButton(t(LKey.gameLeave), showExit),
    ],
  );
}

Widget gameNightViewHeading(Role role) {
  List<Player> controller = role.isGroup
      ? (role as RoleGroup).controller
      : [(role as RoleSingular).controller];

  return padding(
    [8, 0],
    row(
      children: [
        image(
          role.icon,
          height: 100,
          width: 100,
          radius: [6],
        ),
        Expanded(
          child: padding(
            [0, 0, 0, 10],
            column(
              mainAlignment: MainAxisAlignment.center,
              children: [
                padding(
                  [4],
                  text(
                    role.name,
                    size: 20,
                    weight: FontWeight.bold,
                  ),
                ),
                padding(
                  [0],
                  SizedBox(
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: controller
                          .map(
                            (member) => chip(member.name,
                                max: 10, size: 11, spacing: [2]),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget gameNightViewInfos(BuildContext context, List<String> infoList) {
  void displayHelp() {
    showDialog(
      context: context,
      builder: (context) => dialog(
        title: t(LKey.help),
        content: column(children: [
          padding(
            [0, 0, 4, 0],
            titleWithIcon(
              t(LKey.gameNightImportantInfos),
              Icons.announcement_outlined,
            ),
          ),
          column(
            crossAlignment: CrossAxisAlignment.stretch,
            children: infoList.map((txt) {
              return card(
                child: padding([8, 4], paragraph(txt, center: true)),
              );
            }).toList(),
          )
        ]),
        context: context,
      ),
    );
  }

  return padding(
    [4, 0],
    column(
      crossAlignment: CrossAxisAlignment.stretch,
      mainSize: MainAxisSize.max,
      children: [
        inkWell(
          child: padding(
            [4, 0],
            row(
              mainAlignment: MainAxisAlignment.center,
              children: [
                icon(Icons.help_outlined, size: 40),
                padding(
                  [0, 8],
                  text(t(LKey.gameShowRoleHelp)),
                ),
              ],
            ),
          ),
          onClick: displayHelp,
        ),
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
                t(LKey.gameRemainingAbilities),
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
  void next() {
    game.next(context);
  }

  return scaffold(
    appBar: gameBar(
      context,
      t(LKey.gameNight, params: {'count': game.currentTurn}),
      game,
    ),
    body: padding(
      [8, 12],
      column(
        crossAlignment: CrossAxisAlignment.stretch,
        mainAlignment: MainAxisAlignment.start,
        children: [
          gameNightViewHeading(game.currentRole!),
          divider(spacing: [2, 0]),
          gameNightViewInfos(
            context,
            game.currentRole!.getInformations(game.playableRoles),
          ),
          divider(spacing: [2, 0]),
          gameNightViewAbilities(game, context),
          button(
            t(LKey.next),
            next,
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
    iconColor: BaseColors.text,
    collapsedIconColor: BaseColors.text,
    title: titleWithIcon(
      title,
      icon,
      alignment: MainAxisAlignment.start,
    ),
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
          t(LKey.gameDayGuideNightEvents),
          Icons.nightlight_outlined,
          nightInfos,
          expanded: true,
        ),
        guideSection(
          t(LKey.gameDayGuideDayEvents),
          Icons.wb_sunny_outlined,
          dayInfos,
        ),
        guideSection(
          t(LKey.gameDayGuideAlive),
          Icons.group_outlined,
          alivePlayers,
        ),
        guideSection(
          t(LKey.gameDayGuideDead),
          Icons.no_accounts_outlined,
          deadPlayers,
        ),
        guideSection(
          t(LKey.gameDayGuidePhase1),
          Icons.message_outlined,
          discussionSteps,
        ),
        guideSection(
          t(LKey.gameDayGuidePhase2),
          Icons.how_to_vote_outlined,
          voteSteps,
        ),
        guideSection(
          t(LKey.gameDayGuidePhase3),
          Icons.shield_outlined,
          defenseSteps,
        ),
        guideSection(
          t(LKey.gameDayGuidePhase4),
          Icons.cancel_outlined,
          executionSteps,
        ),
      ]),
    ),
  );
}

Widget gameDayView(Game game, BuildContext context) {
  List<String> nightInfos =
      game.getCurrentTurnSummary().map((info) => info.text).toList();

  List<String> dayInfos =
      game.getCurrentDaySummary().map((info) => info.text).toList();

  List<String> alivePlayers = game.playersList
      .map(
        (player) => t(
          LKey.gameDayPlayerAs,
          params: {
            'name': player.name,
            'role': player.mainRole.name,
          },
        ),
      )
      .toList();

  List<String> deadPlayers =
      game.deadPlayers.map((player) => player.name).toList();

  void startNight() {
    showConfirm(
      context,
      t(LKey.gameDayEndTitle),
      t(LKey.gameDayEndText),
      () {
        dismiss(context)();
        game.nextNight();
      },
    );
  }

  void onAbilityClicked(Ability ability) {
    showConfirm(
      context,
      t(LKey.gameDayAbilityUseTitle),
      t(LKey.gameDayAbilityUseText),
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

  return scaffold(
    appBar: gameBar(
      context,
      t(LKey.gameDay, params: {'count': game.currentTurn}),
      game,
    ),
    body: padding(
      [0],
      column(
        crossAlignment: CrossAxisAlignment.stretch,
        children: [
          decoratedBox(
            color: BaseColors.red,
            child: padding(
              [8],
              titleWithIcon(
                t(LKey.gameDayGuide),
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
          decoratedBox(
            color: BaseColors.red,
            child: padding(
              [8],
              titleWithIcon(
                  t(LKey.gameDayUsableAbilities), Icons.subject_rounded),
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
          button(t(LKey.gameNightStart), startNight, flat: true)
        ],
      ),
    ),
  );
}

Widget confirmQuitDialog(BuildContext context) {
  return confirm(
    context,
    t(LKey.gameExitTitle),
    t(LKey.gameExitText),
    () {
      Navigator.popUntil(context, ModalRoute.withName(Screen.home.path));
    },
  );
}

Widget appliedDialog(BuildContext context, String message) {
  return confirm(
    context,
    t(LKey.gameAbilityUsed),
    message,
    dismiss(context),
  );
}

Widget debugDialog(BuildContext context, Game game) {
  List<String> simple = [
    t(LKey.gameDebugAlive, params: {'count': game.playersList.length}),
    t(LKey.gameDebugDead, params: {'count': game.deadPlayers.length}),
    t(LKey.gameDebugVillagers,
        params: {'count': calculateVillagers(game.playersList)}),
    t(LKey.gameDebugWerewolves,
        params: {'count': calculateWolves(game.playersList)}),
    t(LKey.gameDebugSolos, params: {'count': calculateSolos(game.playersList)}),
  ];

  Widget dataView(String data, {IconData icon = Icons.info_outline}) {
    return card(
      child: padding(
        [8],
        titleWithIcon(
          data,
          icon,
          alignment: MainAxisAlignment.start,
        ),
      ),
    );
  }

  Widget roleDebugView(Role role) {
    return card(
      child: padding(
        [8],
        column(
          crossAlignment: CrossAxisAlignment.start,
          children: [
            row(children: [
              image(role.icon, height: 25, width: 25, radius: [5]),
              padding(
                [0, 0, 0, 8],
                text(role.name, weight: FontWeight.w500),
              ),
            ]),
            divider(),
            titleWithIcon(
              t(role.isObsolete ? LKey.obsolete : LKey.playing),
              role.isObsolete ? Icons.error_outline : Icons.done,
              alignment: MainAxisAlignment.start,
            ),
            padding(
              [4, 0],
              role.isGroup
                  ? titleWithIcon(
                      '${(role as RoleGroup).currentPlayers.length}',
                      Icons.people_outline,
                      alignment: MainAxisAlignment.start,
                      color: BaseColors.textSecondary,
                    )
                  : column(
                      crossAlignment: CrossAxisAlignment.stretch,
                      children: [
                        titleWithIcon(
                          ellipsify((role.controller as Player).name, 25),
                          Icons.person_outline,
                          alignment: MainAxisAlignment.start,
                          color: BaseColors.textSecondary,
                        ),
                        if ((role as RoleSingular)
                            .controller
                            .effects
                            .isNotEmpty)
                          padding(
                            [8, 0],
                            titleWithIcon(
                              role.controller.effects
                                  .map((effect) => effectIdToString(effect.id))
                                  .join(' | '),
                              Icons.adjust_sharp,
                              alignment: MainAxisAlignment.start,
                              color: BaseColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  return dialog(
    context: context,
    iconName: Icons.list_alt,
    title: t(LKey.gameDebugTitle),
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
              subTitle(t(LKey.stats)),
            ),
            column(
              crossAlignment: CrossAxisAlignment.stretch,
              children: simple.map((info) => dataView(info)).toList(),
            ),
            divider(),
            padding(
              [8, 0],
              subTitle(t(LKey.roles)),
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
    title: t(LKey.gameWrite),
    dismissible: false,
    content: SizedBox(
      width: 400,
      child: column(
        mainSize: MainAxisSize.min,
        children: [
          paragraph(t(LKey.gameWriteHelp)),
          input(
            TextEditingController(),
            placeholder: t(LKey.gameWritePlaceholder),
            size: 45,
          ),
        ],
      ),
    ),
  );
}

Widget abilityCard(
  Ability ability,
  Function onClick, {
  bool variant = false,
}) {
  bool should = ability.isUnskippable();

  String skipText = t(ability.isUnskippable()
      ? LKey.gameAbilityShouldBeUsed
      : LKey.gameAbilityOptional);

  Color skipColor =
      ability.isUnskippable() ? BaseColors.blond : BaseColors.textSecondary;

  Widget content = padding(
    [12],
    column(
      crossAlignment: CrossAxisAlignment.start,
      children: [
        titleWithIcon(ability.name, Icons.dangerous, size: 15, spacing: []),
        if (variant)
          text(
            ability.owner.getPlayerName(),
            size: 12,
          ),
        divider(spacing: [2, 0]),
        text(
          skipText,
          color: skipColor,
          size: variant ? 10 : 12,
          italic: should,
        ),
        padding(
          [8, 0, 0, 0],
          paragraph(
            ability.description,
            color: BaseColors.textSecondary,
          ),
        )
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
          t(LKey.done),
          () {
            dismiss(context)();
            onNext();
          },
          flat: true,
        ),
      ]);
}

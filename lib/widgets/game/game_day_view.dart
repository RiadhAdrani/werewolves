import 'package:flutter/material.dart';
import 'package:werewolves/models/ability.dart';
import 'package:werewolves/models/game.dart';
import 'package:werewolves/models/player.dart';
import 'package:werewolves/widgets/alert/game_confirm_ability_use.dart';
import 'package:werewolves/widgets/cards/ability_card_view.dart';
import 'package:werewolves/widgets/game/game_app_bar.dart';
import 'package:werewolves/widgets/game/game_day_view_step_section.dart';
import 'package:werewolves/constants/game_advices.dart';
import 'package:werewolves/widgets/game/game_use_ability.dart';
import 'package:werewolves/widgets/text/title_with_icon.dart';

Widget gameDayView(GameModel game, BuildContext context) {
  List<String> nightInformations =
      game.getCurrentTurnSummary().map((info) => info.getText()).toList();

  List<String> dayInformations =
      game.getCurrentDaySummary().map((info) => info.getText()).toList();

  List<String> alivePlayers =
      game.getPlayersList().map((player) => player.getName()).toList();

  return Scaffold(
    appBar: gameAppBar('Day (${game.getCurrentTurn()})', context,
        backgroundColor: Colors.blue[100]!),
    body: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: Colors.grey[300]!,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: smallTitleWithIcon('Guide', Icons.help,
                  alignment: MainAxisAlignment.start),
            ),
          ),
          Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    daySectionView('Night events', Icons.nightlight_outlined,
                        nightInformations,
                        expanded: true),
                    daySectionView(
                        'Day events', Icons.wb_sunny_outlined, dayInformations,
                        expanded: true),
                    daySectionView(
                        'Alive Players', Icons.group_outlined, alivePlayers),
                    daySectionView(
                        'Phase 1 : Discussion', Icons.message_outlined, discussionSteps),
                    daySectionView(
                        'Phase 2 : Vote', Icons.how_to_vote_outlined, voteSteps),
                    daySectionView(
                        'Phase 3 : Defense', Icons.shield_outlined, defenseSteps),
                    daySectionView(
                        'Phase 4 : Execution', Icons.cancel_outlined, executionSteps),
                  ]),
                ),
              )),
          ColoredBox(
            color: Colors.grey[300]!,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: smallTitleWithIcon(
                  'Usable abilities', Icons.subject_rounded,
                  alignment: MainAxisAlignment.start),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                scrollDirection: Axis.vertical,
                children: game.getDayAbilities().map((Ability ability) {
                  return abilityCardView(ability, () {
                    showConfirmAlert('Before using the ability',
                        'Make sure everyone else is asleep.', context, () {
                      showUseAbilityDialog(context, game, ability,
                          (List<Player> targets) {
                        game.useAbilityInDay(ability, targets, context);
                      });
                    });
                  }, variant: true);
                }).toList(),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                showConfirmAlert(
                    'Start night phase',
                    'You are about to start the night phase, are you sure you completed all the steps ?',
                    context, () {
                  game.startTurn();
                });
              },
              child: const Text('Start night'))
        ],
      ),
    ),
  );
}

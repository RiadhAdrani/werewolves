import 'package:werewolves/models/player.dart';
import 'package:werewolves/models/role.dart';
import 'package:werewolves/objects/effects/callsign_effect.dart';
import 'package:werewolves/objects/effects/guessed_effect.dart';
import 'package:werewolves/objects/roles/alien.dart';
import 'package:werewolves/objects/roles/black_wolf.dart';
import 'package:werewolves/objects/roles/captain.dart';
import 'package:werewolves/objects/roles/father_of_wolves.dart';
import 'package:werewolves/objects/roles/garrulous_wolf.dart';
import 'package:werewolves/objects/roles/hunter.dart';
import 'package:werewolves/objects/roles/judge.dart';
import 'package:werewolves/objects/roles/knight.dart';
import 'package:werewolves/objects/roles/protector.dart';
import 'package:werewolves/objects/roles/seer.dart';
import 'package:werewolves/objects/roles/servant.dart';
import 'package:werewolves/objects/roles/shepherd.dart';
import 'package:werewolves/objects/roles/villager.dart';
import 'package:werewolves/objects/roles/witch.dart';
import 'package:werewolves/objects/roles/wolfpack.dart';

abstract class Effect {
  late EffectId type;
  late Role source;
  late bool permanent;
}

enum EffectId {
  isProtected,
  isDevoured,
  isInfected,
  isCursed,
  isRevived,
  isSeen,
  isCountered,
  isHunted,
  isExecuted,
  isSubstitue,
  isServed,
  isServing,
  isJudged,
  isMuted,
  isGuessedByAlien,

  wasMuted,
  wasProtected,
  wasJudged,

  hasCallsign,
  hasInheritedCaptaincy,
  hasSheep,

  shouldTalkFirst,
  shouldSayTheWord,
}

const List<EffectId> fatalStatusEffects = [
  EffectId.isCursed,
  EffectId.isDevoured,
  EffectId.isHunted,
  EffectId.isCountered,
  EffectId.isExecuted,
  EffectId.isGuessedByAlien
];

bool isFatalEffect(EffectId effect) {
  return fatalStatusEffects.contains(effect);
}

String effectIdToString(EffectId effect) {
  switch (effect) {
    case EffectId.isProtected:
      return 'isProtected';
    case EffectId.wasProtected:
      return 'wasProtected';
    case EffectId.isDevoured:
      return 'isDevoured';
    case EffectId.isInfected:
      return 'isInfected';
    case EffectId.isCursed:
      return 'isCursed';
    case EffectId.isRevived:
      return 'isRevived';
    case EffectId.isSeen:
      return 'isSeen';
    case EffectId.isCountered:
      return 'isCountered';
    case EffectId.isHunted:
      return 'isHunted';
    case EffectId.isExecuted:
      return 'isExecuted';
    case EffectId.isSubstitue:
      return 'isSubstitution';
    case EffectId.isServed:
      return 'isServed';
    case EffectId.isServing:
      return 'isServing';
    case EffectId.isJudged:
      return 'isJudged';
    case EffectId.isMuted:
      return 'isMuted';
    case EffectId.wasMuted:
      return 'wasMuted';
    case EffectId.wasJudged:
      return 'wasJudged';
    case EffectId.hasCallsign:
      return 'hasCallsign';
    case EffectId.hasInheritedCaptaincy:
      return 'hasInheritedCaptaincy';
    case EffectId.shouldTalkFirst:
      return 'shouldTalkFirst';
    case EffectId.shouldSayTheWord:
      return 'shouldSayTheWord';
    case EffectId.hasSheep:
      return "hasSheep";
    case EffectId.isGuessedByAlien:
      return "isGuessed";
  }
}

Effect createEffectFromId(EffectId id, Player player) {
  switch (id) {
    case EffectId.isProtected:
      return ProtectedEffect(Protector(player));
    case EffectId.isDevoured:
      return DevourEffect(Wolfpack([player]));
    case EffectId.isInfected:
      return InfectEffect(FatherOfWolves(player));
    case EffectId.isCursed:
      return CurseEffect(Witch(player));
    case EffectId.isRevived:
      return ReviveEffect(Witch(player));
    case EffectId.isSeen:
      return ClairvoyanceEffect(Seer(player));
    case EffectId.isCountered:
      return CounterEffect(Knight(player));
    case EffectId.isHunted:
      return HuntEffect(Hunter(player));
    case EffectId.isExecuted:
      return ExecutedEffect(Captain(player));
    case EffectId.isSubstitue:
      return SubstitueEffect(Villager(player));
    case EffectId.isServed:
      return ServeEffect(Servant(player));
    case EffectId.isServing:
      return ServingEffect(Servant(player));
    case EffectId.isJudged:
      return JudgedEffect(Judge(player));
    case EffectId.isMuted:
      return MuteEffect(BlackWolf(player));
    case EffectId.isGuessedByAlien:
      return GuessEffect(Alien(player));
    case EffectId.wasMuted:
      return WasMutedEffect(BlackWolf(player));
    case EffectId.wasProtected:
      return WasProtectedEffect(Protector(player));
    case EffectId.wasJudged:
      return WasJudgedEffect(Judge(player));
    case EffectId.hasCallsign:
      return CallSignEffect(Hunter(player));
    case EffectId.hasInheritedCaptaincy:
      return InheritCaptaincyEffect(Captain(player));
    case EffectId.hasSheep:
      return SheepEffect(Shepherd(player));
    case EffectId.shouldTalkFirst:
      return TalkerEffect(Captain(player));
    case EffectId.shouldSayTheWord:
      return GarrulousEffect(GarrulousWolf(player));
  }
}

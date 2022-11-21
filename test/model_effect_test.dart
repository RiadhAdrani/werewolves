import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/models/effect.dart';

void main() {
  group('Effect', () {
    void testEffectId(EffectId effect, bool expected) {
      test('should determine if $effect is fatal => $expected', () {
        expect(isFatalEffect(effect), expected);
      });
    }

    for (var effect in EffectId.values) {
      switch (effect) {
        case EffectId.isProtected:
          testEffectId(effect, false);
          break;
        case EffectId.isDevoured:
          testEffectId(effect, true);
          break;
        case EffectId.isInfected:
          testEffectId(effect, false);
          break;
        case EffectId.isCursed:
          testEffectId(effect, true);
          break;
        case EffectId.isRevived:
          testEffectId(effect, false);
          break;
        case EffectId.isSeen:
          testEffectId(effect, false);
          break;
        case EffectId.isCountered:
          testEffectId(effect, true);
          break;
        case EffectId.isHunted:
          testEffectId(effect, true);
          break;
        case EffectId.isExecuted:
          testEffectId(effect, true);
          break;
        case EffectId.isSubstitue:
          testEffectId(effect, false);
          break;
        case EffectId.isServed:
          testEffectId(effect, false);
          break;
        case EffectId.isServing:
          testEffectId(effect, false);
          break;
        case EffectId.isJudged:
          testEffectId(effect, false);
          break;
        case EffectId.isMuted:
          testEffectId(effect, false);
          break;
        case EffectId.isGuessedByAlien:
          testEffectId(effect, true);
          break;
        case EffectId.wasMuted:
          testEffectId(effect, false);
          break;
        case EffectId.wasProtected:
          testEffectId(effect, false);
          break;
        case EffectId.wasJudged:
          testEffectId(effect, false);
          break;
        case EffectId.hasCallsign:
          testEffectId(effect, false);
          break;
        case EffectId.hasInheritedCaptaincy:
          testEffectId(effect, false);
          break;
        case EffectId.hasSheep:
          testEffectId(effect, false);
          break;
        case EffectId.shouldTalkFirst:
          testEffectId(effect, false);
          break;
        case EffectId.hasWord:
          testEffectId(effect, false);
          break;
      }
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/i18n/en.dart';
import 'package:werewolves/i18n/keys.dart';

void main() {
  void testLanguage(Map<LK, String> lang) {
    test('should have same length', () {
      expect(lang.values.length, LK.values.length);
    });

    for (var key in LK.values) {
      test('should have valid key $key', () {
        expect(lang[key].runtimeType, String);
      });
    }
  }

  group('i18n Keys', () {
    group('en - English', () {
      testLanguage(en);
    });

    // group('fr - Français', () {
    //   testLanguage(fr);
    // });
  });
}

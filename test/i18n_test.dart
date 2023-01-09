import 'package:flutter_test/flutter_test.dart';
import 'package:werewolves/i18n/en.dart';
import 'package:werewolves/i18n/keys.dart';

void main() {
  group('i18n Keys', () {
    group('en - English', () {
      test('should have same length', () {
        expect(en.values.length, LKey.values.length);
      });

      for (var key in LKey.values) {
        test('should have valid key $key', () {
          expect(en[key].runtimeType, String);
        });
      }
    });
  });
}

abstract class Assets {
  static String get(String path) {
    return 'assets/$path';
  }

  static String font(String file, {String xt = '.ttf'}) {
    return Assets.get('fonts/$file$xt');
  }

  static String icon(String file, {String xt = '.png'}) {
    return Assets.get('icons/$file$xt');
  }

  static String texture(String file, {String xt = '.png'}) {
    return Assets.get('textures/$file$xt');
  }

  static const String cloth1 = 'cloth1';
  static const String cloth3 = 'cloth3';
  static const String cloth2 = 'cloth2';
  static const String cloth4 = 'cloth4';

  static const String wood1 = 'wood1';
  static const String wood2 = 'wood2';
  static const String wood3 = 'wood3';

  static const String ancient = 'ancient';
  static const String angel = 'ange';
  static const String hunter = 'chasseur';
  static const String knight = 'chevalier';
  static const String judge = 'juge';
  static const String werewolf = 'loup-garou';
  static const String fatherWolf = 'pere-infecte';
  static const String protector = 'salvateur';
  static const String witch = 'sorciere';
  static const String villager = 'villageois';
  static const String seer = 'voyante';
}

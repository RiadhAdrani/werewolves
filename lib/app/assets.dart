abstract class Assets {
  static String get(String path) {
    return 'assets/$path';
  }

  static String icon(String file, {String xt = '.png'}) {
    return Assets.get('icons/$file$xt');
  }

  static String font(String file, {String xt = '.ttf'}) {
    return Assets.get('fonts/$file$xt');
  }

  static String texture(String file, {String xt = '.png'}) {
    return Assets.get('textures/$file$xt');
  }
}

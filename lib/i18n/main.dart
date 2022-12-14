enum Localization { en }

abstract class T {
  final Localization _selected = Localization.en;
}

abstract class Lang {
  late String home;

  Lang(this.home);
}

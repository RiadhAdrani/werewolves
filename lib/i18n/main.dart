enum Localization { en }

abstract class Translation {
  String title;

  Translation({required this.title});
}

class English extends Translation {
  English({
    super.title = 'Werewolves',
  });
}

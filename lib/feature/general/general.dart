enum Mod { development, live }

class General {
  static General? _instance;

  static General get instance {
    _instance ??= General._init();
    return _instance!;
  }

  Mod mod = Mod.live;
  General._init();
  bool get isDevelopementMod => mod==Mod.development;
}

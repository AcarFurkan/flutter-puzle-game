 import 'package:hive/hive.dart';

import '../../core/enums/preferences_keys.dart';

class AppCacheManager {
  final String key;
  Box<String>? _box;

  AppCacheManager(this.key);

  Future<void> init() async {
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

 String getItem(String key) {
   String value="0";
   if (key == PreferencesKeys.level.name) {
     value = "1";
   }
   return _box?.get(key) ?? value;
 }

  Future<void> putItem(String key, String item) async {
    await _box?.put(key, item);
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }
}

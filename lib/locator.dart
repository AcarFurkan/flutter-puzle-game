 import 'package:get_it/get_it.dart';

import 'feature/repository/app_cache_manager.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AppCacheManager("gamecache"));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'feature/general/general.dart';
import 'feature/home_page/virewmodel/cubit/home_cubit.dart';

import 'core/helper/file_helper.dart';
import 'feature/game_page/cubit/game_cubit_cubit.dart';
import 'feature/home_page/view/home_page.dart';
import 'feature/repository/app_cache_manager.dart';
import 'feature/repository/repository.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await FileHelper.instance.readAllLevels();
  await FileHelper.instance.readLevel();
  await Hive.initFlutter();
  if (General.instance.mod == Mod.development) {
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ["2077ef9a63d2b398840261c8221a0c9b"]));
  }

  await MobileAds.instance.initialize();

  setupLocator();

  AppCacheManager _appCacheManager = locator<AppCacheManager>();
  await _appCacheManager.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
          ..copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(primary: Colors.grey))),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeCubit()),
            BlocProvider(create: (context) => GameCubit(context))
          ],
          child: HomePage(),
        ));
  }
}

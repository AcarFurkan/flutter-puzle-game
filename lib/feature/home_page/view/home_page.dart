import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'extension/delegate_start_button.dart';
import '../virewmodel/cubit/home_cubit.dart';

import '../../../core/admob/admob_transactions.dart';
import '../../../core/enums/preferences_keys.dart';
import '../../../core/helper/file_helper.dart';
import '../../../locator.dart';
import '../../game_page/view/game_page.dart';

import '../../general/general.dart';
import '../../repository/app_cache_manager.dart';
import 'extension/sliver_persistent_delegate_extension.dart';
part './extension/static_widget_generations.dart';
part './extension/start_button_extension.dart';
part './extension/level_container_extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late BannerAd banner;
  Color shadowColor = Colors.green;
  late final AppCacheManager _cacheManager;
  late Size size;
  int gridCount = 3;
  @override
  void initState() {
    super.initState();
    fillShadows();
    context.read<HomeCubit>().findRightPage();
    _cacheManager = locator<AppCacheManager>();
    //MobileAds.instance
    //  .getRequestConfiguration()
    //    .then((value) => print(value.testDeviceIds));
    banner = AdmobTransactions.instance.bannerAd()..load();
    _controller = AnimationController(vsync: this);
    AdmobTransactions.instance.fillRewardedAd();
    AdmobTransactions.instance.fillInterstitialAd();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static late Icon iconShadowColor;
  static late Icon iconBorderShadowColor;
  static late Icon iconBorderRed;

  static List<BoxShadow> numberBoxShadow = [];
  static List<BoxShadow> numberBoxShadowRed = [];
  static List<BoxShadow> numberTextBoxShadow = [];

  static List<BoxShadow> numberTextBoxShadowRed = [];
  static List<Icon> zeroStar = [];
  static List<Icon> oneStar = [];
  static List<Icon> twoStar = [];
  static List<Icon> threeStar = [];
  static List<Icon> fourStar = [];
  static List<Icon> fiveStar = [];
  static List<Icon> zeroStarRed = [];

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().checkGridChildCount();

    String? result = _cacheManager.getItem(PreferencesKeys.level.name);
    FileHelper.instance.currentLevelNumber =
        int.parse(_cacheManager.getItem(PreferencesKeys.level.name)) - 1;
    FileHelper.instance.readLevel();
    bool isPressed = false;
    size = MediaQuery.of(context).size;
    generateIcons();
    generateStars();

    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   FileHelper.instance.readfiveLevels().then((value) => print(value));
      // }),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: buildStack(context, isPressed),
        ),
      ),
    );
  }

  Stack buildStack(BuildContext context, bool isPressed) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                      top: size.width * .1, bottom: size.width * .02),
                  sliver: SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    flexibleSpace: showGif(),
                    expandedHeight: size.width * .5,
                  ),
                ),
                SliverPersistentHeader(
                    // floating: true,
                    // pinned: true,
                    delegate: StartButtonDelegate(Column(
                  children: [
                    buildStartGameMethod(isPressed, shadowColor, context),
                    //buildResetButton,
                    //  const SizedBox(height: 25),
                  ],
                ))),
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        int level = int.parse(
                            _cacheManager.getItem(PreferencesKeys.level.name));

                        return buildNumber(
                            (index + 1) +
                                ((context.read<HomeCubit>().currentPage - 1) *
                                    12),
                            (index + 1) +
                                    ((context.read<HomeCubit>().currentPage -
                                            1) *
                                        12) <=
                                level);
                      },
                      childCount: context.read<HomeCubit>().gridChildCount,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                  ),
                ),
                SliverPersistentHeader(delegate: Delegate(buildButtomBar)),
              ]),
        ),
        Positioned(bottom: 0, child: buildAdContainer)
      ],
    );
  }

  Column get buildButtomBar => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: (context.read<HomeCubit>().currentPage - 1) == 0
                      ? null
                      : () {
                          context.read<HomeCubit>().currentPage--;
                          setState(() {});
                        },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
              Text((context.read<HomeCubit>().currentPage).toString()),
              TextButton(
                  onPressed: context.read<HomeCubit>().currentPage ==
                          context.read<HomeCubit>().totalPageCount
                      ? null
                      : () {
                          context.read<HomeCubit>().currentPage++;
                          setState(() {});
                        },
                  child:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white))

              // buildStartGameMethod(isPressed, shadowColor, context),
              // buildResetButton,
              //  const SizedBox(height: 25),
            ],
          ),
          SizedBox(
            height: 50,
          )
        ],
      );

  //Widget buidHomePageListView(Size size, bool isPressed) {
  //  return ListView(
  //    children: [
  //      buildRocketAnimation,
  //      Padding(
  //        padding: EdgeInsets.symmetric(
  //            horizontal: size.width / 6, vertical: size.height / 30),
  //        child: buildStartGameMethod(isPressed, shadowColor, context),
  //      ),
  //      General.instance.isDevelopementMod ? buildResetButton : Container(),
  //      Padding(
  //        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
  //        child: buildLevelsView,
  //      ),
  //    ],
  //  );
  //}

  conGenerator() {
    List<Widget> temp = [];
    int level = int.parse(_cacheManager.getItem(PreferencesKeys.level.name));
    for (var i = 0; i < FileHelper.instance.allLevels.length; i++) {
      temp.add(buildNumber(i + 1, i + 1 <= level));
    }
    return temp;
  }

  // GridView get buildLevelsView => GridView.builder(
  //     clipBehavior: Clip.none,
  //     itemCount: FileHelper.instance.allLevels.length,
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: gridCount, crossAxisSpacing: 15, mainAxisSpacing: 15),
  //     itemBuilder: (BuildContext context, int index) {
  //       int level =
  //           int.parse(_cacheManager.getItem(PreferencesKeys.level.name));
  //       return buildNumber(index + 1, index + 1 <= level);
  //     });

  SizedBox get buildAdContainer => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: banner.size.height.toDouble(),
        child: AdWidget(ad: banner),
      );

  ElevatedButton get buildResetButton => ElevatedButton(
      onPressed: () {
        _cacheManager.clearAll();
        setState(() {});
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.grey[800],
      ),
      child: const Text("reset level"));

  SizedBox get buildRocketAnimation => SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Lottie.asset(
          'assets/animations/rocket_2.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..repeat();
          },
        ),
      );

  showGif() {
    return Image.asset(
      "assets/animations/taxi-2.gif",
      height: size.width * .5,
      // width: ,
    );
  }

/**
 *  BoxShadow(//out
              color: isDone ? shadowColor : Colors.red,
              blurRadius: 5 * i,
              inset: true),
               BoxShadow(//in
              spreadRadius: -1,
              color: isDone ? shadowColor : Colors.red,
              blurRadius: 5 * i,
              blurStyle: BlurStyle.outer)
                BoxShadow(//text
                        color: isDone ? shadowColor : Colors.red,
                        blurRadius: 3 * i,
                        inset: true)
 */
  List<Widget> findRightStars(int star) {
    switch (star) {
      case 0:
        return zeroStar;
      case 1:
        return oneStar;
      case 2:
        return twoStar;
      case 3:
        return threeStar;
      case 4:
        return fourStar;
      case 5:
        return fiveStar;
      default:
        return zeroStar;
    }
  }

  generateIcon(bool isDone) {
    return isDone
        ? Icon(
            Icons.star,
            color: shadowColor,
            size: size.width / (gridCount * 8),
          )
        : Icon(
            Icons.star,
            color: Colors.red,
            size: size.width / (gridCount * 8),
          );
  }

  generateStarWithBorder(bool isDone) {
    return isDone
        ? Icon(
            Icons.star_border,
            color: shadowColor,
            size: size.width / (gridCount * 8),
          )
        : Icon(
            Icons.star_border,
            color: Colors.red,
            size: size.width / (gridCount * 8),
          );
  }

  int findStart(int level) =>
      int.parse(_cacheManager.getItem("level${level.toString()}"));
}

/*
  buildNumber(int level, bool isDone) {
    int star = aa(level);
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        for (double i = 1; i < 5; i++)
          BoxShadow(
              color: isDone ? shadowColor : Colors.red,
              blurRadius: 5 * i,
              inset: true),
        for (double i = 1; i < 5; i++)
          BoxShadow(
              spreadRadius: -1,
              color: isDone ? shadowColor : Colors.red,
              blurRadius: 5 * i,
              blurStyle: BlurStyle.outer)
      ]),
      child: TextButton(
          onPressed: () {
            if (General.instance.isDevelopementMod) {
              FileHelper.instance.readLevelByGivenLevel(level - 1).then(
                  (value) => Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => AniamtedPositionExample()))
                          .then((value) {
                        setState(() {});
                      }));
            } else {
              if (level <=
                  int.parse(
                      _cacheManager.getItem(PreferencesKeys.level.name))) {
                FileHelper.instance.readLevelByGivenLevel(level - 1).then(
                    (value) =>
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) =>
                                    AniamtedPositionExample()))
                            .then((value) {
                          setState(() {});
                        }));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(color: Colors.white, width: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " $level ",
                style: TextStyle(fontSize: 25, color: Colors.white, shadows: [
                  for (double i = 1; i < 8; i++)
                    BoxShadow(
                        color: isDone ? shadowColor : Colors.red,
                        blurRadius: 3 * i,
                        inset: true)
                ]),
              ),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < star; i++) iconShadowColor,
                    for (var i = 0; i < 5 - star; i++)
                      (isDone ? iconBorderShadowColor : iconBorderRed),
                    // generateStarWithBorder(isDone),
                  ],
                ),
              ),
            ],
          )),
    );
  }

 */
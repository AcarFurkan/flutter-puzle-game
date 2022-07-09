import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/admob/admob_transactions.dart';
 import '../../../core/custom_path_animation/stack_path_transition.dart';
import '../../../core/helper/file_helper.dart';

  import '../../../locator.dart';
import '../../general/general.dart';
import '../../repository/app_cache_manager.dart';
import '../../repository/repository.dart';
import '../cubit/game_cubit_cubit.dart';
import 'custom_cell_animated_position.dart';
 
part  './game_page_extensions/animated_position_generator.dart';
part  './game_page_extensions/top_stack_extension.dart';
part  './game_page_extensions/bottom_stack_extension.dart';
part  './game_page_extensions/game_board_stack_extension.dart';
part  './game_page_extensions/init_extension.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameRepository.instance.context = context;
    GameRepository.instance.width = MediaQuery.of(context).size.width;
    //
    GameRepository.instance.fillListFromFile(); //
    return BlocProvider(
      create: (context) => GameCubit(context),
      child: const Scaffold(
        body: Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late List<double> startTilePosition;
  late AnimationController _controller;

  late Animation _animation;
  late double ballRadius;
  Color shadowColor = Colors.green;

  Color textShadowColor = Colors.orange;
  int currentLevel = 1;
  List<Widget> stackList = [];
  double positionY = 0;
  double startPointX = 0;
  double startPointY = 0;
  double? targetX = 0;
  double? targetY = 0;
  late BannerAd bannerBottom;
  int destinationPointX = 0;
  int destinationPointY = 0;
  double curvedValue = 15;
  late final AppCacheManager cacheManager;

  final imageKey = GlobalKey();

  @override
  void initState() {
    initTransactions();
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    checkLevelForRewardAd();

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildTopStack(size),
        buildGameBoardStack(size),
        buildBottomStack(size),
      ],
    );
  }

  Future<void> checkLevelForRewardAd() async {
    AdmobTransactions.instance.fillRewardedAd();
    AdmobTransactions.instance.fillInterstitialAd();
  }

  showRewardedDialog() {
    AwesomeDialog(
      btnOkText: "Next Level",
      btnCancelText: "Home Page",
      context: context,
                      dismissOnTouchOutside: false,

      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Niceeee',
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < 5; i++)
                  Icon(Icons.star, color: Colors.green[300]),
                for (var i = 0; i < 0; i++)
                  Icon(Icons.star_border, color: Colors.green[300]),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      //desc: 'Dialog description here.............',
      btnCancelOnPress: () {
        Navigator.pop(context); //Named e dönüp düzeteceğim
      },
      btnOkOnPress: () async {
        //  Navigator.pop(context);

        await nextLevelActions(context);
      },
    ).show();
  }

  Future<void> nextLevelActions(BuildContext context) async {
    if (currentLevel % 3 == 0) {
      if (AdmobTransactions.instance.rewardedAd == null) {
        AdmobTransactions.instance.fillRewardedAd();
      } else {
        await AdmobTransactions.instance.rewardedAd!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          // Reward the user for watching an ad.
        });
      }
    } else {
      if (AdmobTransactions.instance.interstitialAd == null) {
        AdmobTransactions.instance.fillInterstitialAd();
      } else {
        AdmobTransactions.instance.interstitialAd!.show();
      }
    }

    _controller.reset();
    GameRepository.instance.newGameLevel();

    // FileHelper.instance.incrementLevel();
    await FileHelper.instance.readLevel();
    currentLevel = FileHelper.instance.currentLevelNumber + 1;

    GameRepository.instance.fillListFromFile();
    context.read<GameCubit>().moveCount = 0;

    setState(() {});
    context.read<GameCubit>().runListener();

    context.read<GameCubit>().emitInitial();
  }

  Future<void> previousLevelActions(BuildContext context) async {
    _controller.reset();
    GameRepository.instance.newGameLevel();

    FileHelper.instance.decreaseLevel();
    await FileHelper.instance.readLevel();
    currentLevel = FileHelper.instance.currentLevelNumber + 1;

    GameRepository.instance.fillListFromFile();
    context.read<GameCubit>().moveCount = 0;

    setState(() {});
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}
/*
class DrawClip extends CustomClipper<Path> {
  double value;
  double slice = math.pi;
  DrawClip({required this.value});
  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(0, size.height * 0.8);
    path.lineTo(0, 0);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(value * slice);
    double a = 69 * math.cos(value * slice);
    if (a < 0) {
      a = -a;
    }
    // double yCenter = size.height * 0.2 + a;
    double yCenter = a;
    path.quadraticBezierTo(xCenter, yCenter, size.width, 0);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}*/
/*
class DrawClipTwo extends CustomClipper<Path> {
  double value;
  double slice = math.pi;
  DrawClipTwo({required this.value});
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6) * math.sin(value * slice);
    double a = 69 * math.cos(value * slice);
    if (a < 0) {
      a = -a;
    }
    // double yCenter = size.height * 0.2 + a;
    double yCenter = a;
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}*/
/**
 * AnimatedBuilder buildAnimatedBuilderBottom(Size size) {
    return AnimatedBuilder(
        animation: topWaveController,
        builder: (context, child) {
          return ClipPath(
            clipper: DrawClip(value: topWaveController.value),
            child: Container(
              height: size.height / 10,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Color(0xFFE0647B), Color(0xFFFCDD89)])),
            ),
          );
        });
  }

  AnimatedBuilder buildAnimatedBuilderTop(Size size) {
    return AnimatedBuilder(
        animation: topWaveController,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft, end: Alignment.topRight,
                    //colors: [Color(0xFFE0647B), Color(0xFFFCDD89)])),
                    colors: [Colors.yellow.shade700, Colors.orange])),
            child: ClipPath(
              clipper: DrawClipTwo(value: topWaveController.value),
              child: Container(
                height: size.height / 10,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ),
          );
        });
  }

 */
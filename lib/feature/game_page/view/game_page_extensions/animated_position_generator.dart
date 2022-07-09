part of '../game_page.dart';

extension AnimatedPositionGenerator on _MyStatefulWidgetState {
  Offset calculate(value) {
    PathMetrics pathMetrics     = GameRepository.instance.path.computeMetrics();

    PathMetric pathMetric = pathMetrics.elementAt(0);

    value = pathMetric.length * value;

    Tangent? pos = pathMetric.getTangentForOffset(value);

    return pos!.position;
  }

  List<Widget> animatedPositionGenerator(double width, GlobalKey key) {
    //bunu pathlere eklersen daha gözel olur
    GameRepository.instance.stackTopPosition = 0;
    double topPosition = GameRepository.instance.stackTopPosition;
    GameRepository.instance.width = width;
    ballRadius = width / 18;
    stackList.clear();
    GameRepository.instance.fillBallStartPosition();

    stackList.add(SizedBox(
      //  color: Colors.blue,
      height: width + topPosition * 2,
      width: width + topPosition * 2,
    ));

    stackList.add(
      Positioned(
        top: topPosition,
        child: Opacity(
          opacity: 0.9,
          child: Image.asset(
            "assets/images/bg_mobile.png",
            key: key,
            height: width,
            width: width,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );

    int id = 0;

    GameRepository.instance.listTwoDim.clear();

    for (var i = 0; i < GameRepository.instance.boardColumnCount; i++) {
      // Repository.listTwoDim.add([]);
      GameRepository.instance.listTwoDim.add([]);
      for (var j = 0; j < GameRepository.instance.boardColumnCount; j++) {
        late final AnimationController _controller = AnimationController(
          lowerBound: 0.5,
          duration: const Duration(milliseconds: 500),
          vsync: this,
        );
        GameRepository.instance.listTwoDim[i].add(CustomCellAnimatedPositioned(
          x: j * width / GameRepository.instance.boardColumnCount,
          y: i * width / GameRepository.instance.boardColumnCount + topPosition,
          id: id,
          controller: _controller,
          tile: GameRepository.instance.tileList[id],
        ));

        id++;
      }
    }

    for (var listItem in GameRepository.instance.listTwoDim) {
      for (var item in listItem) {
        stackList.add(item);
      }
    }

    GameRepository.instance.fillBallStartPosition();
    context.read<GameCubit>().emitInitial(); // TODO: destroy this

    var ball = BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is GameDone) {
          context.read<GameCubit>().ballAnimation.addListener(() {
            if (context.read<GameCubit>().ballAnimation.isCompleted) {
              int move = context.read<GameCubit>().moveCount;
              int star = 5;
              if (move <= 4) {
                star = 5;
              } else if (move <= 8) {
                star = 4;
              } else if (move <= 12) {
                star = 3;
              } else if (move <= 16) {
                star = 2;
              } else {
                star = 1;
              }
              context.read<GameCubit>().star = star;
              context.read<GameCubit>().savelevelStar();
              AwesomeDialog(
                btnOkText: "Next Level",
                btnCancelText: "Home Page",
                dismissOnTouchOutside: false,
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Niceeee',
                body: Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < star; i++)
                            Icon(Icons.star, color: Colors.green[300]),
                          for (var i = 0; i < 5 - star; i++)
                            Icon(Icons.star_border, color: Colors.green[300]),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: inset.BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              for (double i = 1; i < 5; i++)
                                inset.BoxShadow(
                                    color: shadowColor,
                                    blurRadius: 5 * i,
                                    inset: true),
                              for (double i = 1; i < 5; i++)
                                inset.BoxShadow(
                                    spreadRadius: -1,
                                    color: shadowColor,
                                    blurRadius: 5 * i,
                                    blurStyle: BlurStyle.outer)
                            ]),
                        child: TextButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              side: BorderSide(color: Colors.white, width: 4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () async {
                              if (AdmobTransactions.instance.rewardedAd ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Sorry, you can't watch ads right now 🙁")));
                              } else {
                                await AdmobTransactions.instance.rewardedAd!
                                    .show(onUserEarnedReward: (AdWithoutView ad,
                                        RewardItem rewardItem) {
                                  // Reward the user for watching an ad.
                                  context.read<GameCubit>().moveCount = 4;
                                  context.read<GameCubit>().emitInitial();
                                  context.read<GameCubit>().star = 5;
                                  context.read<GameCubit>().savelevelStar();

                                  setState(() {});
                                  Navigator.pop(context);
                                  showRewardedDialog();
                                  // Navigator.pop(context);
                                });
                              }
                            },
                            child: Text(
                              "Click and watch video to get 5 stars",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  shadows: [
                                    for (double i = 1; i < 8; i++)
                                      inset.BoxShadow(
                                          color: shadowColor,
                                          blurRadius: 3 * i,
                                          inset: true)
                                  ]),
                            )),
                      ),
                      SizedBox(height: 10),
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
          });
        }
      },
      builder: (context, state) {
        return buildBall(topPosition);
      },
    );

    stackList.add(ball);
    // stackList.add(Text(text));
    // stackList.add(CustomPaint(
    //   painter: PathPainter(GameRepository.instance.path),
    // ));

    return stackList;
  }

  Positioned buildBall(double topPosition) {
    return Positioned(
      top: ((_animation.status == AnimationStatus.forward ||
              _animation.status == AnimationStatus.completed)
          ? calculate(_animation.value).dy - ballRadius / 2
          : GameRepository.instance.startTilePosition[1] -
              ballRadius / 2), // TODO: get ball radius dynamic
      left: (_animation.status == AnimationStatus.forward ||
              _animation.status == AnimationStatus.completed)
          ? calculate(_animation.value).dx - ballRadius / 2
          : GameRepository.instance.startTilePosition[0] - ballRadius / 2,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.white, Color(0xff646464)]),
            borderRadius: BorderRadius.circular(50)),
        width: ballRadius,
        height: ballRadius,
      ),
    );
  }
}

class DrawClipInsideStack extends CustomClipper<Path> {
  double value;
  double slice = math.pi;
  DrawClipInsideStack({required this.value});
  @override
  Path getClip(Size size) {
    Path path = Path();
    // path.lineTo(0, size.height * 0.8);
    path.lineTo(0, size.height / 2);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(value * slice);
    double a = 69 * math.cos(value * slice);
    if (a < 0) {
      // a = -a;
    }
    // double yCenter = size.height * 0.2 + a;
    double yCenter = a;
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height / 2);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
/**
 *  var bottom = AnimatedBuilder(
        animation: topWaveController,
        builder: (context, child) {
          return ClipPath(
            clipper: DrawClipInsideStack(value: topWaveController.value),
            child: Container(
              height: topPosition,
              width: width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Color(0xFFE0647B), Color(0xFFFCDD89)])),
            ),
          );
        });
 */

part of '../game_page.dart';

extension BottomStackExtension on _MyStatefulWidgetState {
  Stack buildBottomStack(Size size) {
    return Stack(
      children: [
        buildBottomBackgroundImage(size),
        Positioned(
          top: size.height / 55,
          child: buildMoveText(size),
        ),
        General.instance.isDevelopementMod
            ? Positioned(top: 150, child: buildNextPreviousLevel)
            : Container(),
        Positioned(
          bottom: 0,
          child: buildBottomBunner,
        ),
      ],
    );
  }

  Image buildBottomBackgroundImage(Size size) => Image.asset(
        "assets/images/bg_mobile.png",
        height: (size.height - size.width) / 2,
        width: size.width,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
      );

  SizedBox buildMoveText(Size size) => SizedBox(
        width: size.width,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: BlocBuilder<GameCubit, GameState>(
                  builder: (context, state) {
                    return Text(
                      "Move: ${context.read<GameCubit>().moveCount}    ",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          shadows: [
                            for (double i = 1; i < 8; i++)
                              inset.BoxShadow(
                                  color: textShadowColor,
                                  blurRadius: 5 * i,
                                  inset: true)
                          ]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Row get buildNextPreviousLevel => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [buildPreviousButton, buildNextButton],
      );

  SizedBox get buildBottomBunner {
    BannerAd bannerBottom = AdmobTransactions.instance.bannerAd();
    bannerBottom.load();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: bannerBottom.size.height.toDouble(),
      child: AdWidget(ad: bannerBottom),
    );
  }

  ElevatedButton get buildPreviousButton => //this is for test
      ElevatedButton(
        onPressed: currentLevel == 1
            ? null
            : () async {
                await previousLevelActions(context);
              },
        child: Row(
            children: const [Icon(Icons.arrow_back), Text("Previous Level  ")]),
        style: ElevatedButton.styleFrom(primary: Colors.grey[800]),
      );

  ElevatedButton get buildNextButton => ElevatedButton(
        //this is for test
        onPressed: !(currentLevel < FileHelper.instance.allLevels.length)
            ? null
            : () async {
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
              },
        child: Row(children: const [Text("Next Level  "), Icon(Icons.forward)]),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[800],
        ),
      );
}

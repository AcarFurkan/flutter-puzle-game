part of '../home_page.dart';

extension LevelContainerExtension on _HomePageState {
  buildNumber(int level, bool isDone) {
    int star = findStart(level);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: isDone
              ? _HomePageState.numberBoxShadow
              : _HomePageState.numberBoxShadowRed),
      child: TextButton(
          onPressed: () {
            if (General.instance.isDevelopementMod) {
              FileHelper.instance.readLevelByGivenLevel(level - 1).then(
                  (value) => Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => GamePage()))
                          .then((value) {
                            context.read<HomeCubit>().findRightPage();
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
                                    GamePage()))
                            .then((value) {
                                                          context.read<HomeCubit>().findRightPage();

                          setState(() {});
                        }));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: const BorderSide(color: Colors.white, width: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " $level ",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    shadows: isDone
                        ? _HomePageState.numberTextBoxShadow
                        : _HomePageState.numberTextBoxShadowRed),
              ),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: isDone
                      ? findRightStars(star)
                      : _HomePageState.zeroStarRed,
                ),
              ),
            ],
          )),
    );
  }
}

part of '../game_page.dart';
extension InitExtension on _MyStatefulWidgetState{
    void initTransactions() {
    cacheManager = locator<AppCacheManager>();

    if (AdmobTransactions.instance.rewardedAd == null) {
      AdmobTransactions.instance.fillRewardedAd();
    }
    if (AdmobTransactions.instance.interstitialAd == null) {
      AdmobTransactions.instance.fillInterstitialAd();
    }
    currentLevel = FileHelper.instance.currentLevelNumber + 1;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<GameCubit>().setGameBoardSize();
    });
    context.read<GameCubit>().ballController = _controller;

    GameRepository.instance.context = context;
    GameRepository.instance.width =
        MediaQuery.of(context.read<GameCubit>().context).size.width;
    context.read<GameCubit>().runListener();
     _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    context.read<GameCubit>().ballAnimation = _animation;
    checkLevelForRewardAd();
  }
}
part of '../home_page.dart';

extension StartButtonExtension on _HomePageState {
  Listener buildStartGameMethod(
      bool isPressed, Color shadowColor, BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() {
        isPressed = true;
      }),
      onPointerUp: (_) => setState(() {
        isPressed = false;
      }),
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          for (double i = 1; i < 5; i++)
            BoxShadow(
                color: shadowColor,
                blurRadius: (isPressed ? 5 : 3) * i,
                inset: true),
          for (double i = 1; i < 5; i++)
            BoxShadow(
                spreadRadius: -1,
                color: shadowColor,
                blurRadius: (isPressed ? 5 : 3) * i,
                blurStyle: BlurStyle.outer)
        ]),
        child: TextButton(
            onHover: ((value) {
              setState(() {
                isPressed = value;
              });
            }),
            onPressed: () {
              int level =
                  int.parse(_cacheManager.getItem(PreferencesKeys.level.name));
              FileHelper.instance.readLevelByGivenLevel(level - 1).then(
                  (value) => Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => GamePage()))
                          .then((value) {
                        context.read<HomeCubit>().findRightPage();

                        setState(() {});
                      }));
              //  Navigator.of(context)
              //      .push(MaterialPageRoute(
              //          builder: (context) => AniamtedPositionExample()))
              //      .then((value) {
              //    context.read<HomeCubit>().findRightPage();

              //    setState(() {});
              //  });
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(color: Colors.white, width: 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              " Start Game ",
              style: TextStyle(fontSize: 25, color: Colors.white, shadows: [
                for (double i = 1; i < (isPressed ? 8 : 4); i++)
                  BoxShadow(color: shadowColor, blurRadius: 3 * i, inset: true)
              ]),
            )),
      ),
    );
  }
}

part of '../game_page.dart';

extension TopStackExtension on _MyStatefulWidgetState {
  Stack buildTopStack(Size size) {
    return Stack(
      children: [
        buildTopStackBackground(size),
        Positioned(
          top: size.height / 15,
          child: buildLevelText(size),
        ),
        Positioned(
          top: size.height / 17,
          left: size.width / 15,
          child: buildExitButton(size),
        )
      ],
    );
  }

  Image buildTopStackBackground(Size size) => Image.asset(
        "assets/images/bg_mobile.png",
        height: (size.height - size.width) / 2,
        width: size.width,
        fit: BoxFit.fitWidth,
        alignment: Alignment.bottomCenter,
      );

  SizedBox buildLevelText(Size size) => SizedBox(
      width: size.width,
      child: Center(
          child: Text(
        "Level: $currentLevel",
        style: TextStyle(fontSize: 25, color: Colors.white, shadows: [
          for (double i = 1; i < 8; i++)
            inset.BoxShadow(
                color: textShadowColor, blurRadius: 6 * i, inset: true)
        ]),
      )));

  Container buildExitButton(Size size) => Container(
        decoration: buildExitButtonDecoration,
        child: SizedBox(
          child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: buildTextButtonStyle,
              child: Text(
                " X ",
                style: buildExitButtonTextStyle,
              )),
        ),
      );

  BoxDecoration get buildExitButtonDecoration =>
      BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        for (double i = 1; i < 5; i++)
          inset.BoxShadow(color: Colors.red, blurRadius: 5 * i, inset: true),
        for (double i = 1; i < 5; i++)
          inset.BoxShadow(
              spreadRadius: -1,
              color: Colors.red,
              blurRadius: 5 * i,
              blurStyle: BlurStyle.outer)
      ]);

  ButtonStyle get buildTextButtonStyle => TextButton.styleFrom(
        minimumSize: const Size(10, 10),
        elevation: 0,
        //  padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: const BorderSide(color: Colors.white, width: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );
  TextStyle get buildExitButtonTextStyle => TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            for (double i = 1; i < 8; i++)
              inset.BoxShadow(color: Colors.red, blurRadius: 3 * i, inset: true)
          ]);
}

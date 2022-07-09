part of '../home_page.dart';

extension StaticWidgetGeneration on _HomePageState {
  void generateIcons() {
    _HomePageState.iconShadowColor = Icon(
      Icons.star,
      color: shadowColor,
      size: size.width / (gridCount * 8),
    );

    _HomePageState.iconBorderShadowColor = Icon(
      Icons.star_border,
      color: shadowColor,
      size: size.width / (gridCount * 8),
    );
    _HomePageState.iconBorderRed = Icon(
      Icons.star_border,
      color: Colors.red,
      size: size.width / (gridCount * 8),
    );
  }

  generateStars() {
    _HomePageState.zeroStar = [
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
    ];
    _HomePageState.oneStar = [
      _HomePageState.iconShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
    ];
    _HomePageState.twoStar = [
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
    ];
    _HomePageState.threeStar = [
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconBorderShadowColor,
      _HomePageState.iconBorderShadowColor,
    ];
    _HomePageState.fourStar = [
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconBorderShadowColor,
    ];
    _HomePageState.fiveStar = [
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
      _HomePageState.iconShadowColor,
    ];
    _HomePageState.zeroStarRed = [
      _HomePageState.iconBorderRed,
      _HomePageState.iconBorderRed,
      _HomePageState.iconBorderRed,
      _HomePageState.iconBorderRed,
      _HomePageState.iconBorderRed,
    ];
  }

  fillShadows() {
    for (double i = 1; i < 5; i++) {
      _HomePageState.numberBoxShadow
          .add(BoxShadow(color: shadowColor, blurRadius: 5 * i, inset: true));
    }

    for (double i = 1; i < 5; i++) {
      _HomePageState.numberBoxShadow.add(BoxShadow(
          spreadRadius: -1,
          color: shadowColor,
          blurRadius: 5 * i,
          blurStyle: BlurStyle.outer));
    }

    for (double i = 1; i < 5; i++) {
      _HomePageState.numberBoxShadowRed
          .add(BoxShadow(color: Colors.red, blurRadius: 5 * i, inset: true));
    }

    for (double i = 1; i < 5; i++) {
      _HomePageState.numberBoxShadowRed.add(BoxShadow(
          spreadRadius: -1,
          color: Colors.red,
          blurRadius: 5 * i,
          blurStyle: BlurStyle.outer));
    }
    for (double i = 1; i < 8; i++) {
      _HomePageState.numberTextBoxShadow
          .add(BoxShadow(color: shadowColor, blurRadius: 3 * i, inset: true));
    }

    for (double i = 1; i < 8; i++) {
      _HomePageState.numberTextBoxShadowRed
          .add(BoxShadow(color: Colors.red, blurRadius: 3 * i, inset: true));
    }
  }
}

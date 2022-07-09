part of '../game_page.dart';

extension GameBoardStackExtension on _MyStatefulWidgetState {
  Stack buildGameBoardStack(Size size) {
    return Stack(
      children: [
        buildGameBoardBackgroundImage(size),
        AnimatedPathDemo(
            child: buildGameBoard(context, size), curvedValue: curvedValue),
      ],
    );
  }

  Image buildGameBoardBackgroundImage(Size size) => Image.asset(
        "assets/images/bg_mobile.png",
        height: size.width,
        width: size.width,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
      );

  Widget buildGameBoard(BuildContext context, Size size) {
    size = Size(
        size.width - context.read<GameCubit>().gameBoardPadding, size.height);
    return IgnorePointer(
      ignoring: false,
      child: GestureDetector(
        onVerticalDragStart: (e) {
          print("start");
      
          print(e.globalPosition);
          List temp = context.read<GameCubit>().findTileLocation(
              imageKey.globalPaintBounds!.top,
              e.globalPosition.dx,
              e.globalPosition.dy);
          startPointX = e.globalPosition.dx;
          startPointY = e.globalPosition.dy;
          print(e.globalPosition.dx);
          print(e.globalPosition.dy);
        },
        onVerticalDragUpdate: (e) {
          print(e.globalPosition);
          targetX = e.globalPosition.dx;
          targetY = e.globalPosition.dy;
        },
        onVerticalDragEnd: (e) {
          List temp = context.read<GameCubit>().findTileLocation(
              imageKey.globalPaintBounds!.top, targetX!, targetY!);
          destinationPointX = temp[0];
          destinationPointY = temp[1];
      
          context.read<GameCubit>().makeMoveNew(imageKey.globalPaintBounds!.top,
              targetX!, targetY!, startPointX, startPointY);
        },
        child: Center(
          child: SizedBox(
            height: size.width,
            width: size.width,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(curvedValue),
                child: Stack(
                  key: context.read<GameCubit>().gameBoardKey,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  children: animatedPositionGenerator(size.width, imageKey),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/**
 *   Widget buildGameBoard(BuildContext context, Size size) {
    size = Size(
        size.width - context.read<GameCubit>().gameBoardPadding, size.height);
    return GestureDetector(
      onVerticalDragStart: (e) {
        print("start");

        print(e.globalPosition);
        List temp = context.read<GameCubit>().findTileLocation(
            imageKey.globalPaintBounds!.top,
            e.globalPosition.dx,
            e.globalPosition.dy);
        startPointX = temp[0];
        startPointY = temp[1];
        print(e.globalPosition.dx);
        print(e.globalPosition.dy);
      },
      onVerticalDragUpdate: (e) {
        print(e.globalPosition);
        targetX = e.globalPosition.dx;
        targetY = e.globalPosition.dy;
      },
      onVerticalDragEnd: (e) {
        List temp = context.read<GameCubit>().findTileLocation(
            imageKey.globalPaintBounds!.top, targetX!, targetY!);
        destinationPointX = temp[0];
        destinationPointY = temp[1];

        context.read<GameCubit>().makeMove(
            destinationPointX, destinationPointY, startPointX, startPointY);
      },
      child: Center(
        child: SizedBox(
          height: size.width,
          width: size.width,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(curvedValue),
              child: Stack(
                key: context.read<GameCubit>().gameBoardKey,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: animatedPositionGenerator(size.width, imageKey),
              ),
            ),
          ),
        ),
      ),
    );
  }
 */
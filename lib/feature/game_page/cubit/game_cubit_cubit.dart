import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/enums/preferences_keys.dart';
import '../../../core/helper/file_helper.dart';
import '../../../locator.dart';
import '../../abstract/movable.dart';

import '../../concrete/empty_free_tile.dart';
import '../../concrete/start_tile.dart';
import '../../repository/app_cache_manager.dart';
import '../../repository/repository.dart';
import '../view/custom_cell_animated_position.dart';

part 'game_cubit_state.dart';
part './extension/tile_generation.dart';

class GameCubit extends Cubit<GameState> {
  BuildContext context;
  late AnimationController ballController;
  late Animation ballAnimation;
  int _moveCount = 0;
  double gameBoardPadding = 5;
  bool ignorePointerIsActive = false;

  late Size size;
  late Size gameBoardSize;
  late GlobalKey gameBoardKey = GlobalKey();
  late final AppCacheManager _cacheManager;
  int star = 0;

  GameCubit(this.context) : super(GameInitial()) {
    _cacheManager = locator<AppCacheManager>();
  }
  setGameBoardSize() {
    size = size = Size(context.size!.width, context.size!.height);
    gameBoardSize =
        Size(context.size!.width - gameBoardPadding, context.size!.height);
  }

  @override
  close() async {
    super.close();
  }

  runListener() {
    ballController.clearListeners();
    ballController.addListener(() {
      emit(GameInitial());
    });
  }

  emitInitial() {
    emit(GameInitial());
  }

  int get moveCount => _moveCount;

  set moveCount(int move) {
    _moveCount = move;
  }

  incrementMoveCount() {
    _moveCount++;
  }

  makeMoveNew(double gameBoardTopStartPosition, destinationX, destinationY,
      startX, startY) {
    if (gameBoardTopStartPosition > destinationY) {
      destinationY = gameBoardTopStartPosition;
    } else if (gameBoardTopStartPosition +
            gameBoardKey.currentContext!.size!.width <
        destinationY) {
      destinationY =
          gameBoardTopStartPosition + gameBoardKey.currentContext!.size!.width;
    }

    List tempStart =
        findTileLocation(gameBoardTopStartPosition, startX, startY);
    startX = tempStart[0];
    startY = tempStart[1];
    List tempDestination =
        findTileLocation(gameBoardTopStartPosition, destinationX, destinationY);
    destinationX = tempDestination[0];
    destinationY = tempDestination[1];
    int difX = (destinationX - startX).abs().toInt();
    int difY = (destinationY - startY).abs().toInt();

    double width = gameBoardKey.currentContext!.size!.width /
        GameRepository.instance.boardColumnCount;

    if (!ballController.isAnimating) {
      if ((difX >= 1 && difY >= 1)) {
      } else {
        if (destinationX > startX) {
          destinationX = startX + 1;
          changeTileLocation(destinationX, startX, width, startY, destinationY);

          print(destinationX);
        } else if (destinationX < startX) {
          destinationX = startX - 1;
          changeTileLocation(destinationX, startX, width, startY, destinationY);
        } else {}
        if (destinationY > startY) {
          destinationY = startY + 1;
          changeTileLocation(destinationX, startX, width, startY, destinationY);
        } else if (destinationY < startY) {
          destinationY = startY - 1;
          changeTileLocation(destinationX, startX, width, startY, destinationY);
        } else {}
      }
    }
  }

  void changeTileLocation(
      destinationX, startX, double width, startY, destinationY) {
    CustomCellAnimatedPositioned start =
        GameRepository.instance.listTwoDim[startY][startX];
    CustomCellAnimatedPositioned destination =
        GameRepository.instance.listTwoDim[destinationY][destinationX];
    if (start.tile is! Movable ||
        (destination.tile is! EmptyFreeTile) ||
        start.tile is EmptyFreeTile) {
      return;
    }

    if (destinationX > startX) {
      start.x += width;
      destination.x -= width;

      GameRepository.instance.listTwoDim[startY][startX] = destination;
      GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
    } else if (destinationX < startX) {
      start.x -= width;
      destination.x += width;
      GameRepository.instance.listTwoDim[startY][startX] = destination;
      GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
    } else {}
    if (destinationY > startY) {
      start.y += width;
      destination.y -= width;
      GameRepository.instance.listTwoDim[startY][startX] = destination;
      GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
    } else if (destinationY < startY) {
      start.y -= width;
      destination.y += width;
      GameRepository.instance.listTwoDim[startY][startX] = destination;
      GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
    } else {}
    incrementMoveCount();

    checkGameIsDone();

    emit(GameInitial());
  }

  makeMove(int destinationX, destinationY, startX, startY) {
    double width = gameBoardKey.currentContext!.size!.width /
        GameRepository.instance.boardColumnCount;

    CustomCellAnimatedPositioned start =
        GameRepository.instance.listTwoDim[startY][startX];
    CustomCellAnimatedPositioned destination =
        GameRepository.instance.listTwoDim[destinationY][destinationX];
    int difX = (destinationX - startX).abs().toInt();
    int difY = (destinationY - startY).abs().toInt();

    if (difX > 1 ||
        difY > 1 ||
        (difX == 1 && difY == 1) ||
        start.tile is! Movable ||
        (destination.tile is! EmptyFreeTile) ||
        start.tile is EmptyFreeTile) {
      return;
    } else {
      incrementMoveCount();
      if (destinationX > startX) {
        start.x += width;
        destination.x -= width;

        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else if (destinationX < startX) {
        start.x -= width;
        destination.x += width;
        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else {}
      if (destinationY > startY) {
        start.y += width;
        destination.y -= width;
        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else if (destinationY < startY) {
        start.y -= width;
        destination.y += width;
        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else {}
      checkGameIsDone();

      emit(GameInitial());
    }
  }

  savelevelStar() {
    _cacheManager.putItem(
        "level${(FileHelper.instance.currentLevelNumber).toString()}",
        star.toString());
  }

  checkGameIsDone() {
    int count = -1;
    for (var items in GameRepository.instance.listTwoDim) {
      for (var item in items) {
        count++;
        if (item.tile is StartTile) {
          if ((item.tile as StartTile).isContinue(null)) {
            // print(GameRepository.instance.)
            ignorePointerIsActive = true;
            Future.delayed(Duration(milliseconds: 750), () {
              ballController.forward();
              FileHelper.instance.incrementLevel();
              int savedLevel =
                  int.parse(_cacheManager.getItem(PreferencesKeys.level.name));

              if ((FileHelper.instance.currentLevelNumber + 1) > savedLevel) {
                _cacheManager.putItem(PreferencesKeys.level.name,
                    (FileHelper.instance.currentLevelNumber + 1).toString());
                _cacheManager.putItem(
                    "level${(FileHelper.instance.currentLevelNumber).toString()}",
                    star.toString());
              }
              emit(GameDone());
              emit(GameInitial());
            });
          }
        }
      }
    }
  }

//GameRepository.instance.boardColumnCount
  List<int> findTileLocation(double top, double x, double y) {
    int j = 0; // x axis
    int i = 0; //y axis
    double width = MediaQuery.of(context).size.width; //TODO :BUNLAR DOĞRUMU BAK
    if (x >= 0 && x <= width / GameRepository.instance.boardColumnCount) {
      j = 0;
      i = findYLocation(top, y);
    }
    if (x >= width / GameRepository.instance.boardColumnCount &&
        x <= (width / GameRepository.instance.boardColumnCount) * 2) {
      j = 1;
      i = findYLocation(top, y);
    }
    if (x >= (width / GameRepository.instance.boardColumnCount) * 2 &&
        x <= (width / GameRepository.instance.boardColumnCount) * 3) {
      j = 2;
      i = findYLocation(top, y);
    }
    if (x >= (width / GameRepository.instance.boardColumnCount) * 3 &&
        x <= (width / GameRepository.instance.boardColumnCount) * 4) {
      j = 3;
      i = findYLocation(top, y);
    }
    if (x >= (width / GameRepository.instance.boardColumnCount) * 4 &&
        x <= (width / GameRepository.instance.boardColumnCount) * 5) {
      j = 4;
      i = findYLocation(top, y);
    }
    if (x >= (width / GameRepository.instance.boardColumnCount) * 5 &&
        x <= (width / GameRepository.instance.boardColumnCount) * 6) {
      j = 5;
      i = findYLocation(top, y);
    }
    if (x >= (width / GameRepository.instance.boardColumnCount) * 6 &&
        x <= width) {
      j = 6;
      i = findYLocation(top, y);
    }

    return [j, i];
  }

  int findYLocation(double top, double y) {
    double width = MediaQuery.of(context).size.width; //TODO :BUNLAR DOĞRUMU BAK
    if (y >= top &&
        y <= (width / GameRepository.instance.boardColumnCount) + top) {
      return 0;
    }
    if (y >= (top + width / GameRepository.instance.boardColumnCount) &&
        y <= (width / GameRepository.instance.boardColumnCount) * 2 + top) {
      return 1;
    }
    if (y >= (top + width / (GameRepository.instance.boardColumnCount * 2)) &&
        y <= (width / GameRepository.instance.boardColumnCount) * 3 + top) {
      return 2;
    }
    if (y >= (top + width / (GameRepository.instance.boardColumnCount * 3)) &&
        y <= (width / GameRepository.instance.boardColumnCount) * 4 + top) {
      return 3;
    }
    if (y >= (top + width / (GameRepository.instance.boardColumnCount * 4)) &&
        y <= (width / GameRepository.instance.boardColumnCount) * 5 + top) {
      return 4;
    }
    if (y >= (top + width / (GameRepository.instance.boardColumnCount * 5)) &&
        y <= (width / GameRepository.instance.boardColumnCount) * 6 + top) {
      return 5;
    }
    if (y >= (top + width / (GameRepository.instance.boardColumnCount * 6)) &&
        y <= (width / GameRepository.instance.boardColumnCount) * 7 + top) {
      return 6;
    }
    return 0;
  }
}
/**?
 *   List<int> findTileLocation(double top, double x, double y) {
    int j = 0; // x axis
    int i = 0; //y axis
    double width = MediaQuery.of(context).size.width; //TODO :BUNLAR DOĞRUMU BAK
    if (x >= 0 && x <= width / 4) {
      j = 0;
      i = findYLocation(top, y);
    }
    if (x >= width / 4 && x <= (width / 4) * 2) {
      j = 1;
      i = findYLocation(top, y);
    }
    if (x >= (width / 4) * 2 && x <= (width / 4) * 3) {
      j = 2;
      i = findYLocation(top, y);
    }
    if (x >= (width / 4) * 3 && x <= width) {
      j = 3;
      i = findYLocation(top, y);
    }

    return [j, i];
  }

  int findYLocation(double top, double y) {
    double width = MediaQuery.of(context).size.width; //TODO :BUNLAR DOĞRUMU BAK
    if (y >= top && y <= (width / 4) + top) {
      return 0;
    }
    if (y >= (top + width / 4) && y <= (width / 4) * 2 + top) {
      return 1;
    }
    if (y >= (top + width / 4 * 2) && y <= (width / 4) * 3 + top) {
      return 2;
    }
    if (y >= (top + width / 4 * 3) && y <= (width / 4) * 4 + top) {
      return 3;
    }
    return 0;
  }
 *//*
    double width = gameBoardKey.currentContext!.size!.width /
        GameRepository.instance.boardColumnCount;

    CustomAnimatedPositioned start =
        GameRepository.instance.listTwoDim[startY][startX];
    CustomAnimatedPositioned destination =
        GameRepository.instance.listTwoDim[destinationY][destinationX];
    int difX = (destinationX - startX).abs().toInt();
    int difY = (destinationY - startY).abs().toInt();

    if (difX > 1 ||
        difY > 1 ||
        (difX == 1 && difY == 1) ||
        start.tile is! Movable ||
        (destination.tile is! EmptyFreeTile) ||
        start.tile is EmptyFreeTile) {
      return;
    } else {
      incrementMoveCount();
      if (destinationX > startX) {
        start.x += width;
        destination.x -= width;

        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else if (destinationX < startX) {
        start.x -= width;
        destination.x += width;
        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else {}
      if (destinationY > startY) {
        start.y += width;
        destination.y -= width;
        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else if (destinationY < startY) {
        start.y -= width;
        destination.y += width;
        GameRepository.instance.listTwoDim[startY][startX] = destination;
        GameRepository.instance.listTwoDim[destinationY][destinationX] = start;
      } else {}
      checkGameIsDone();

      emit(GameInitial());
    }*/
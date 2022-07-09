import 'dart:math';

import 'package:flutter/material.dart';
import '../../core/helper/file_helper.dart';
import '../abstract/pipe.dart';
import '../abstract/tile.dart';
import '../concrete/curved_pipe.dart';
import '../concrete/curved_pipe_static.dart';

import '../concrete/empty_free_tile.dart';
import '../concrete/empty_tile.dart';
import '../concrete/end_tile.dart';
import '../concrete/pipe_static.dart';
import '../concrete/pipe_tile.dart';
import '../concrete/start_tile.dart';
import '../game_page/view/custom_cell_animated_position.dart';

class GameRepository {
  static GameRepository? _instance;
  List<double> startTilePosition = [];
  double stackTopPosition = 0;
  late BuildContext context;
  late double width;
  int boardColumnCount = 4;
  late double moveUnit;

  List<Pipe> pipeList = [];
  //List<CustomAnimatedPositioned> list = [];
  List<List<CustomCellAnimatedPositioned>> listTwoDim = [[]];
  List<Tile> tileList = [];
  List<List<Tile>> tileListTwoDim = []; //just for fun
  newGameLevel() {
    pipeList.clear();
    listTwoDim.clear();
    tileList.clear();
    tileListTwoDim.clear(); //just for fun
  }

  static GameRepository get instance {
    _instance ??= GameRepository._init();
    return _instance!;
  }

  Path path = Path();

  GameRepository._init();

  //List<String> pathList = [];
  void fillListFromFile() {
    tileListTwoDim.clear(); //just for fun

    for (var item in FileHelper.instance.tilesInfoList) {
      tileList.add(generateTiles(item.split(",")));
    }
    boardColumnCount = sqrt(tileList.length).toInt();

    moveUnit = width / (boardColumnCount * 2);
    int count = 0;
    for (var i = 0; i < boardColumnCount; i++) {
      tileListTwoDim.add([]);

      for (var j = 0; j < boardColumnCount; j++) {
        tileListTwoDim[i].add(tileList[count]);
        count++;
      }
    }
  }

  fillBallStartPosition() {
    for (var i = 0; i < tileListTwoDim.length; i++) {
      for (var j = 0; j < tileListTwoDim[i].length; j++) {
        if (tileListTwoDim[i][j] is StartTile) {
          double xCenter =
              (width / (boardColumnCount * 2)) + (width / boardColumnCount) * j;
          double yCenter =
              (width / (boardColumnCount * 2)) + (width / boardColumnCount) * i;
          if (startTilePosition.isEmpty) {
            startTilePosition.addAll([xCenter, yCenter]);
          } else {
            startTilePosition[0] = xCenter;
            startTilePosition[1] =
                yCenter + GameRepository.instance.stackTopPosition;
          }
        }
      }
    }
  }

  Tile generateTiles(List<String> list) {
    String id = list[0].trim();
    String type = list[1].toLowerCase().trim();
    String property = list[2].toLowerCase().trim();
    String path;
    switch (type) {
      case "starter":
        switch (property) {
          case "verticaldown":
            path = "Starter-Vertical-Down.png";
            return StartTile(id, type, property, path);
          case "verticalup":
            path = "Starter-Vertical-Up.png";
            return StartTile(id, type, property, path);
          case "horizontalright":
            path = "Starter-Horizontal-Right.png";
            return StartTile(id, type, property, path);
          case "horizontalleft":
            path = "Starter-Horizontal-Left.png";
            return StartTile(id, type, property, path);
          default:
            path = "Starter-Vertical-Down.png";
            return StartTile(id, type, property, path);
        }
      case "end":
        switch (property) {
          case "verticalup":
            path = "End-Vertical-Up.png";
            return EndTile(id, type, property, path);
          case "verticaldown":
            path = "End-Vertical-Down.png";
            return EndTile(id, type, property, path);
          case "horizontalleft":
            path = "End-Horizontal-Left.png";
            return EndTile(id, type, property, path);
          case "horizontalright":
            path = "End-Horizontal-Right.png";
            return EndTile(id, type, property, path);
          default:
            path = "End-Vertical-Down.png";
            return EndTile(id, type, property, path);
        }

      case "empty":
        switch (property) {
          case "none":
            path = "Empty-None.png";
            return EmptyTile(id, type, property, path);
          case "free":
            path = "Empty-Free.png";
            return EmptyFreeTile(id, type, property, path);
          default:
            path = "Empty-None.png";
            return EmptyTile(id, type, property, path);
        }

      case "pipe":
        switch (property) {
          case "vertical":
            path = "Pipe-Vertical.png";
            return PipeTile(id, type, property, path);
          case "horizontal":
            path = "Pipe-Horizontal.png";
            return PipeTile(id, type, property, path);
          case "00":
            path = "Pipe-00.png";
            return CurvedPipe(id, type, property, path);
          case "01":
            path = "Pipe-01.png";
            return CurvedPipe(id, type, property, path);
          case "10":
            path = "Pipe-10.png";
            return CurvedPipe(id, type, property, path);
          case "11":
            path = "Pipe-11.png";
            return CurvedPipe(id, type, property, path);
          default:
            path = "Pipe-Vertical.png";
            return PipeTile(id, type, property, path);
        }

      case "pipestatic":
        switch (property) {
          case "vertical":
            path = "PipeStatic-Vertical.png";
            return PipeStatic(id, type, property, path);
          case "horizontal":
            path = "PipeStatic-Horizontal.png";
            return PipeStatic(id, type, property, path);
          case "00":
            path = "PipeStatic-00.png";
            return CurvedPipeStatic(id, type, property, path);
          case "01":
            path = "PipeStatic-01.png";
            return CurvedPipeStatic(id, type, property, path);
          case "10":
            path = "PipeStatic-10.png";
            return CurvedPipeStatic(id, type, property, path);
          case "11":
            path = "PipeStatic-11.png";
            return CurvedPipeStatic(id, type, property, path);
          default:
            path = "PipeStatic-Vertical.png";
            return PipeStatic(id, type, property, path);
        }

      default:
        print("default worked");
        return EmptyFreeTile(id, type, property, "Empty-Free.png");
    }
  }
}

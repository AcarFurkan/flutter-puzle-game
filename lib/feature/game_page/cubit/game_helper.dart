import 'package:flutter/material.dart';

import '../../abstract/tile.dart';
import '../../repository/repository.dart';

class GameHelper {
  static GameHelper? _instance;
  static GameHelper get instance {
    _instance ??= GameHelper._init();
    return _instance!;
  }
 
  GameHelper._init();


  List<double> findTileCenterPosition(Tile tile) {
    double width = GameRepository.instance.width;
    //return [width,width];
    List temp = findTileInTwoDim(tile);
    int x = temp[0];
    int y = temp[1];
    double xCenter = (width /  (GameRepository.instance.boardColumnCount*2)) + (width / GameRepository.instance.boardColumnCount) * x;
    double yCenter = (width /(GameRepository.instance.boardColumnCount*2)) + (width / GameRepository.instance.boardColumnCount) * y +
        GameRepository.instance.stackTopPosition;
    return [xCenter, yCenter];
  }

  List findTileInTwoDim(Tile tile) {
    // find position as dot
    List<int> positions = [];
    var list = GameRepository.instance.listTwoDim;
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list[i].length; j++) {
        if (list[i][j].tile.id == tile.id) {
          positions.add(j);
          positions.add(i);
          return positions;
        }
      }
    }

    print("dont contain");
    return positions;
  }
}

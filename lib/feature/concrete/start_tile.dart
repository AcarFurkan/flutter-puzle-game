import 'dart:ui';

import '../../core/enums/properties_enum.dart';
import '../abstract/pipe.dart';
import '../abstract/tile.dart';
import '../game_page/cubit/game_helper.dart';
import '../repository/repository.dart';

class StartTile extends Pipe {
  StartTile(String id, String type, String property, String path)
      : super(id, type, property, path);

  StartTile.fromTile(Tile tile) : super.fromTile(tile);

  @override
  void addPath() {
   // double width = GameRepository.instance.width;

    double thisX = GameHelper.instance.findTileCenterPosition(this)[0];
    double thisY = GameHelper.instance.findTileCenterPosition(this)[1];
    GameRepository.instance.path.moveTo(thisX, thisY);
    switch (getProperty) {
      case Properties.HORIZONTALLEFT: //left
        GameRepository.instance.path.lineTo(thisX - GameRepository.instance.moveUnit, thisY);
        break;
      case Properties.HORIZONTALRIGHT:
        GameRepository.instance.path.lineTo(thisX +  GameRepository.instance.moveUnit, thisY);
        break;
      case Properties.VERTICALDOWN: //down
        GameRepository.instance.path.lineTo(thisX, thisY +  GameRepository.instance.moveUnit);
        break;
      case Properties.VERTICALUP:
        GameRepository.instance.path.lineTo(thisX, thisY -  GameRepository.instance.moveUnit);
        break;
      default:
    }
    // TODO: implement addPath
  }

  @override
  bool isContinue(Tile? previousTile) {
    GameRepository.instance.path = Path();
    GameRepository.instance.pipeList.clear();
    GameRepository.instance.pipeList.add(this);
    addPath();
  print("start tile check start");
    int x = GameHelper.instance.findTileInTwoDim(this)[0];
    int y = GameHelper.instance.findTileInTwoDim(this)[1];

    var twoDim = GameRepository.instance.listTwoDim;
    switch (getProperty) {
      case Properties.HORIZONTALLEFT: //done
        if (twoDim[y][x - 1].tile is Pipe) {
          //x i kontrol etsen iyi olur
          Pipe secondTile = twoDim[y][x - 1].tile as Pipe;
          if (secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
              secondTile.getProperty == Properties.CURVED_ONE_ONE ||
              secondTile.getProperty == Properties.HORIZONTAL) {
            return secondTile.isContinue(this);
          } else {
            return false;
          }
        }

        return false;
      case Properties.HORIZONTALRIGHT:
        if (twoDim[y][x + 1].tile is Pipe) {
          //x i kontrol etsen iyi olur
          Pipe secondTile = twoDim[y][x + 1].tile as Pipe;
          if (secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
              secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
              secondTile.getProperty == Properties.HORIZONTAL) {
            return secondTile.isContinue(this);
          } else {
            return false;
          }
        }

        return false;
      case Properties.VERTICALDOWN: //down
        if (twoDim[y + 1][x].tile is Pipe) {
          Pipe secondTile = twoDim[y + 1][x].tile as Pipe;
          if (secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
              secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
              secondTile.getProperty == Properties.VERTICAL) {
            

            return secondTile.isContinue(this);
          } else {
            return false;
          }
        }
        return false;
      case Properties.VERTICALUP: //down
        if (twoDim[y - 1][x].tile is Pipe) {
          Pipe secondTile = twoDim[y - 1][x].tile as Pipe;
          if (secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
              secondTile.getProperty == Properties.CURVED_ONE_ONE ||
              secondTile.getProperty == Properties.VERTICAL) {
            return secondTile.isContinue(this);
          } else {
            return false;
          }
        }
        return false;
      default:
        return false;
    }
  }
}

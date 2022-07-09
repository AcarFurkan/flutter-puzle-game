import '../../core/enums/properties_enum.dart';
import '../abstract/pipe.dart';
import '../abstract/tile.dart';
import '../game_page/cubit/game_helper.dart';
import '../repository/repository.dart';

class CurvedPipeStatic extends Pipe {
  CurvedPipeStatic(String id, String type, String property, String path)
      : super(id, type, property, path);

  CurvedPipeStatic.fromTile(Tile tile) : super.fromTile(tile);

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

    return positions;
  }

  @override
  void addPath() {
    double width = GameRepository.instance.width;

    double thisX = GameHelper.instance.findTileCenterPosition(this)[0];
    double thisY = GameHelper.instance.findTileCenterPosition(this)[1];

    Tile tile;
    double previousX;
    double previousY;

    switch (getProperty) {
      case Properties.CURVED_ZERO_ZERO:
        tile = GameRepository.instance
            .pipeList[GameRepository.instance.pipeList.indexOf(this) - 1];
        previousX = GameHelper.instance.findTileCenterPosition(tile)[0];
        previousY = GameHelper.instance.findTileCenterPosition(tile)[1];

        if (thisX > previousX) {
          // GO TO right up

          GameRepository.instance.path.cubicTo(
              thisX - GameRepository.instance.moveUnit,
              thisY,
              thisX,
              thisY,
              thisX,
              thisY - GameRepository.instance.moveUnit);
        } else {
          // GO TO LEFT

          GameRepository.instance.path.cubicTo(
              thisX,
              thisY - GameRepository.instance.moveUnit,
              thisX,
              thisY,
              thisX - GameRepository.instance.moveUnit,
              thisY);
        }
        break;
      case Properties.CURVED_ZERO_ONE:
        tile = GameRepository.instance
            .pipeList[GameRepository.instance.pipeList.indexOf(this) - 1];
        previousX = GameHelper.instance.findTileCenterPosition(tile)[0];
        previousY = GameHelper.instance.findTileCenterPosition(tile)[1];

        if (thisY > previousY) {
          // GO TO down

          GameRepository.instance.path.cubicTo(
              thisX,
              thisY - GameRepository.instance.moveUnit,
              thisX,
              thisY,
              thisX + GameRepository.instance.moveUnit,
              thisY);
        } else {
          // GO TO LEFT

          GameRepository.instance.path.cubicTo(
              thisX + GameRepository.instance.moveUnit,
              thisY,
              thisX,
              thisY,
              thisX,
              thisY - GameRepository.instance.moveUnit);
        }
        break;
      case Properties.CURVED_ONE_ZERO:
        tile = GameRepository.instance
            .pipeList[GameRepository.instance.pipeList.indexOf(this) - 1];
        previousX = GameHelper.instance.findTileCenterPosition(tile)[0];
        previousY = GameHelper.instance.findTileCenterPosition(tile)[1];

        if (thisX > previousX) {
          GameRepository.instance.path.cubicTo(
              thisX - GameRepository.instance.moveUnit,
              thisY,
              thisX,
              thisY,
              thisX,
              thisY + GameRepository.instance.moveUnit);
        } else {
          GameRepository.instance.path.cubicTo(
              thisX,
              thisY + GameRepository.instance.moveUnit,
              thisX,
              thisY,
              thisX - GameRepository.instance.moveUnit,
              thisY);
        }
        break;
      case Properties.CURVED_ONE_ONE:
        tile = GameRepository.instance
            .pipeList[GameRepository.instance.pipeList.indexOf(this) - 1];
        previousX = GameHelper.instance.findTileCenterPosition(tile)[0];
        previousY = GameHelper.instance.findTileCenterPosition(tile)[1];

        if (thisY > previousY) {
          //DOWN TO TOP
          //   print("THİSSS" * 25);
          GameRepository.instance.path.cubicTo(
              thisX,
              thisY + GameRepository.instance.moveUnit,
              thisX,
              thisY,
              thisX + GameRepository.instance.moveUnit,
              thisY);
        } else if (thisY < previousY) {
          //TOP TO DOWN
          //COPY PASTE
          GameRepository.instance.path.cubicTo(
              thisX,
              thisY + GameRepository.instance.moveUnit,
              thisX,
              thisY,
              thisX + GameRepository.instance.moveUnit,
              thisY);
        } else if (previousX < thisX) {
          GameRepository.instance.path.cubicTo(
              thisX + GameRepository.instance.moveUnit,
              thisY,
              thisX,
              thisY,
              thisX,
              thisY + GameRepository.instance.moveUnit);
        } else if (previousX > thisX) {
          GameRepository.instance.path.cubicTo(
              thisX + GameRepository.instance.moveUnit,
              thisY,
              thisX,
              thisY,
              thisX,
              thisY + GameRepository.instance.moveUnit);
        } else {
          GameRepository.instance.path.cubicTo(
              thisX + GameRepository.instance.moveUnit,
              thisY,
              thisX,
              thisY,
              thisX,
              thisY + GameRepository.instance.moveUnit);
          //GameRepository.instance.path.cubicTo(
          //   thisX, thisY +  GameRepository.instance.moveUnit, thisX, thisY, thisX +  GameRepository.instance.moveUnit, thisY);
        }
        break;
      default:
        break;
    }
  }

  @override
  bool isContinue(Tile previousTile) {
    // TODO: implement isContinue
    print("curved pipe  check is start");
    GameRepository.instance.pipeList.add(this);
    addPath();
    int x = findTileInTwoDim(this)[0];
    int y = findTileInTwoDim(this)[1];
    var twoDim = GameRepository.instance.listTwoDim;

    switch (getProperty) {
      case Properties.CURVED_ZERO_ZERO:
        if (x > 0) {
          //left
          if ((twoDim[y][x - 1].tile is Pipe)) {
            Pipe secondTile = twoDim[y][x - 1].tile as Pipe;

            if (secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.HORIZONTALRIGHT) {
              if (!((secondTile.id == (previousTile.id)))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        if (y > 0) {
          if ((twoDim[y - 1][x].tile is Pipe)) {
            //up
            Pipe secondTile = twoDim[y - 1][x].tile as Pipe;

            if (secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.VERTICALDOWN) {
              if (!(secondTile.id == (previousTile.id))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        return false;
      case Properties.CURVED_ZERO_ONE:
        if (x < GameRepository.instance.boardColumnCount - 1) {
          if ((twoDim[y][x + 1].tile is Pipe)) {
            Pipe secondTile = twoDim[y][x + 1].tile as Pipe;

            if (secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.HORIZONTALLEFT) {
              if (!(secondTile.id == (previousTile.id))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        if (y > 0) {
          if ((twoDim[y - 1][x].tile is Pipe)) {
            Pipe secondTile = twoDim[y - 1][x].tile as Pipe;

            if (secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.VERTICALDOWN) {
              if (!(secondTile.id == (previousTile.id))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        return false;

      case Properties.CURVED_ONE_ZERO:
        if (x > 0) {
          if ((twoDim[y][x - 1].tile is Pipe)) {
            Pipe secondTile = twoDim[y][x - 1].tile as Pipe;

            if (secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.HORIZONTALRIGHT) {
              if (!(secondTile.id == (previousTile.id))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        if (y < GameRepository.instance.boardColumnCount - 1) {
          if ((twoDim[y + 1][x].tile is Pipe)) {
            Pipe secondTile = twoDim[y + 1][x].tile as Pipe;

            if (secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.VERTICALUP) {
              if (!(secondTile.id == (previousTile.id))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        return false;

      case Properties.CURVED_ONE_ONE:
        if (x < GameRepository.instance.boardColumnCount - 1) {
          if ((twoDim[y][x + 1].tile is Pipe)) {
            Pipe secondTile = twoDim[y][x + 1].tile as Pipe;

            if (secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.HORIZONTALLEFT) {
              if (!(secondTile.id == (previousTile.id))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        if (y < GameRepository.instance.boardColumnCount - 1) {
          if ((twoDim[y + 1][x].tile is Pipe)) {
            Pipe secondTile = twoDim[y + 1][x].tile as Pipe;

            if (secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.VERTICALUP) {
              if (!(secondTile.id == (previousTile.id))) {
                return secondTile.isContinue(this);
              }
            }
          }
        }
        return false;

      default:
        return false;
    }
  }
}

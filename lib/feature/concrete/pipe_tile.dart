import '../../core/enums/properties_enum.dart';
import '../abstract/movable.dart';
import '../abstract/pipe.dart';
import '../abstract/tile.dart';
import '../game_page/cubit/game_helper.dart';
import '../repository/repository.dart';

class PipeTile extends Pipe implements Movable {
  PipeTile(String id, String type, String property, String path)
      : super(id, type, property, path);

  PipeTile.fromTile(Tile tile) : super.fromTile(tile);

  @override
  void addPath() {
    double width = GameRepository.instance.width;

    double thisX = GameHelper.instance.findTileCenterPosition(this)[0];
    double thisY = GameHelper.instance.findTileCenterPosition(this)[1];
    Tile tile = GameRepository
        .instance.pipeList[GameRepository.instance.pipeList.indexOf(this) - 1];
    double previousX = GameHelper.instance.findTileCenterPosition(tile)[0];
    double previousY = GameHelper.instance.findTileCenterPosition(tile)[1];
    switch (getProperty) {
      case Properties.HORIZONTAL:
        if (thisX > previousX) {
          // GO TO RİGHT
          GameRepository.instance.path.lineTo(thisX +  GameRepository.instance.moveUnit, thisY);
        } else {
          // GO TO LEFT
          GameRepository.instance.path.lineTo(thisX -  GameRepository.instance.moveUnit, thisY);
        }

        break;
      case Properties.VERTICAL:
        if (thisY > previousY) {
          GameRepository.instance.path.lineTo(thisX, thisY +  GameRepository.instance.moveUnit);
        } else {
          GameRepository.instance.path.lineTo(thisX, thisY -  GameRepository.instance.moveUnit);
        }
        break;
      default:
        break;
    }
    // TODO: implement addPath
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

  @override
  bool isContinue(Tile previousTile) {
    print("pipe tile check is start");
    GameRepository.instance.pipeList.add(this);
    addPath();
    int x = findTileInTwoDim(this)[0];
    int y = findTileInTwoDim(this)[1];
    var twoDim = GameRepository.instance.listTwoDim;

    switch (getProperty) {
      case Properties.HORIZONTAL:
        if (x == 0) {
          // sağı kontrol et
          if ((twoDim[y][x + 1].tile is Pipe)) {
            Pipe secondTile = twoDim[y][x + 1].tile as Pipe;

            if (secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.HORIZONTALLEFT) {
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }
          return false;
        }
        if (x == GameRepository.instance.boardColumnCount-1) {
          // solu kontrol et
          if ((twoDim[y][x - 1].tile is Pipe)) {
            Pipe secondTile = twoDim[y][x - 1].tile as Pipe;

            if (secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.HORIZONTALRIGHT) {
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }
          return false;
        } else {
          // iki tarafıda kontrol et
          if ((twoDim[y][x - 1].tile is Pipe)) {
            // sol
            Pipe secondTile = twoDim[y][x - 1].tile as Pipe;

            if (secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.HORIZONTALRIGHT) {
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }

          if ((twoDim[y][x + 1].tile is Pipe)) {
            // sağ
            Pipe secondTile = twoDim[y][x + 1].tile as Pipe;

            if (secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.HORIZONTAL ||
                secondTile.getProperty == Properties.HORIZONTALLEFT) {
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }
          return false;
        }
      case Properties.VERTICAL:
        if (y == 0) {
          // alt
          if ((twoDim[y + 1][x].tile is Pipe)) {
            Pipe secondTile = twoDim[y + 1][x].tile as Pipe;

            if (secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.VERTICALUP) {
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }
          return false;
        }
        if (y == GameRepository.instance.boardColumnCount-1) {
          // üst
          if ((twoDim[y - 1][x].tile is Pipe)) {
            Pipe secondTile = twoDim[y - 1][x].tile as Pipe;

            if (secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.VERTICALDOWN) {
              secondTile.id;
              previousTile.id;
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }
          return false;
        } else {
          // both

          if ((twoDim[y + 1][x].tile is Pipe)) {
            //down
            Pipe secondTile = twoDim[y + 1][x].tile as Pipe;
            if (secondTile.getProperty == Properties.CURVED_ZERO_ZERO ||
                secondTile.getProperty == Properties.CURVED_ZERO_ONE ||
                secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.VERTICALUP) {
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }
          if ((twoDim[y - 1][x].tile is Pipe)) {
            //up
            Pipe secondTile = twoDim[y - 1][x].tile as Pipe;

            if (secondTile.getProperty == Properties.CURVED_ONE_ZERO ||
                secondTile.getProperty == Properties.CURVED_ONE_ONE ||
                secondTile.getProperty == Properties.VERTICAL ||
                secondTile.getProperty == Properties.VERTICALDOWN) {
              if (!(secondTile.id == previousTile.id)) {
                return secondTile.isContinue(this);
              }
            }
          }
          return false;
        }

      default:
        return false;
    }
  }
}

import '../../core/enums/properties_enum.dart';
import '../abstract/pipe.dart';
import '../abstract/tile.dart';
import '../game_page/cubit/game_helper.dart';
import '../repository/repository.dart';

class EndTile extends Pipe {
  EndTile(String id, String type, String property, String path)
      : super(id, type, property, path);

  @override
  void addPath() {
    double thisX = GameHelper.instance.findTileCenterPosition(this)[0];
    double thisY = GameHelper.instance.findTileCenterPosition(this)[1];
    switch (getProperty) {
      case Properties.HORIZONTALLEFT:
        GameRepository.instance.path.lineTo(thisX, thisY);
        break;
      case Properties.HORIZONTALRIGHT:
        GameRepository.instance.path.lineTo(thisX, thisY);
        break;
      case Properties.VERTICALDOWN:
        GameRepository.instance.path.lineTo(thisX, thisY);
        break;
      case Properties.VERTICALUP:
        GameRepository.instance.path.lineTo(thisX, thisY);
        break;
      default:
    }
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
    // TODO: implement isContinue
    print("end check is start");
    GameRepository.instance.pipeList.add(this);
    addPath();
    int x = findTileInTwoDim(this)[0];
    int y = findTileInTwoDim(this)[1];
    var twoDim = GameRepository.instance.listTwoDim;
     switch (getProperty) {
      case Properties.HORIZONTALLEFT: //left
        if ((twoDim[y][x - 1].tile is Pipe)) {
          if (previousTile.getProperty == Properties.CURVED_ONE_ONE ||
              previousTile.getProperty == Properties.CURVED_ZERO_ONE ||
              previousTile.getProperty == Properties.HORIZONTAL) {
            return true;
          }
        }
        return false;
      case Properties.HORIZONTALRIGHT:
        if ((twoDim[y][x + 1].tile is Pipe)) {
          if (previousTile.getProperty == Properties.CURVED_ZERO_ZERO ||
              previousTile.getProperty == Properties.CURVED_ONE_ZERO ||
              previousTile.getProperty == Properties.HORIZONTAL) {
            return true;
          }
        }
        return false;

      case Properties.VERTICALDOWN: //down
        if ((twoDim[y + 1][x].tile is Pipe)) {
           // Pipe previousTile = (Pipe) twoDim[y + 1][x];
          if (previousTile.getProperty == Properties.CURVED_ZERO_ONE ||
              previousTile.getProperty == Properties.CURVED_ZERO_ZERO ||
              previousTile.getProperty == Properties.VERTICAL) {
            return true;
          }
        }
        return false;
      case Properties.VERTICALUP:
        if ((twoDim[y - 1][x].tile is Pipe)) {
          // Pipe previousTile = (Pipe) twoDim[y + 1][x];
          if (previousTile.getProperty == Properties.CURVED_ONE_ZERO ||
              previousTile.getProperty == Properties.CURVED_ONE_ONE ||
              previousTile.getProperty == Properties.VERTICAL) {
            return true;
          }
        }
        return false;
      default:
        return false;
    }
  }
}

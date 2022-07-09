import '../abstract/movable.dart';
import '../abstract/tile.dart';

class EmptyFreeTile extends Tile implements Movable {
  EmptyFreeTile(String id, String type, String property, String path)
      : super(id, type, property, path);
}

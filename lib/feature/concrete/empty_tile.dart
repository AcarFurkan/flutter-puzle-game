import '../abstract/movable.dart';
import '../abstract/tile.dart';

class EmptyTile extends Tile implements Movable {
  EmptyTile.fromTile(Tile tile) : super.fromTile(tile);

  EmptyTile(String id, String type, String property, String path)
      : super(id, type, property, path);
}

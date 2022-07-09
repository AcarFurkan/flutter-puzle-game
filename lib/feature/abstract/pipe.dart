 
import 'tile.dart';

abstract class Pipe extends Tile {
  Pipe(String id, String type, String property, String path)
      : super(id, type, property, path);

  Pipe.fromTile(Tile tile) : super.fromTile(tile);

  bool isContinue( Tile previousTile);

  void addPath();
}

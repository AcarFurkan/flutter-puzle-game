part of '../game_cubit_cubit.dart';

extension TileGenerationExtension on GameCubit {
/*  void fillListFromFile() {
    for (var item in FileHelper.instance.level) {
      print("111111"*10);
      GameRepository.instance. tileList.add(generateTiles(item.split(",")));
    }
  }

  Tile generateTiles(List<String> list) {
    String id = list[0];
    String type = list[1].toLowerCase();
    String property = list[2].toLowerCase();
    String path;
    List<String> imagePathList = [];
    switch (type) {
      case "starter":
        switch (property) {
          case "vertical":
            path = "Starter-Vertical.png";
            return StartTile(id, type, property, path);
          case "horizontal":
            path = "Starter-Horizontal.png";
            return StartTile(id, type, property, path);
          default:
            path = "Starter-Vertical.png";
            return StartTile(id, type, property, path);
        }

      case "end":
        switch (property) {
          case "vertical":
            path = " End-Vertical.png";
            return EndTile(id, type, property, path);
          case "horizontal":
            path = "End-Horizontal.png";
            return EndTile(id, type, property, path);
          default:
            path = "End-Vertical.png";
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
            return PipeTile(id, type, property, path);
          case "01":
            path = "Pipe-01.png";
            return PipeTile(id, type, property, path);
          case "10":
            path = "Pipe-10.png";
            return PipeTile(id, type, property, path);
          case "11":
            path = "Pipe-11.png";
            return PipeTile(id, type, property, path);
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
            return PipeStatic(id, type, property, path);
          case "01":
            path = "PipeStatic-01.png";
            return PipeStatic(id, type, property, path);
          case "10":
            path = "PipeStatic-10.png";
            return PipeStatic(id, type, property, path);
          case "11":
            path = "PipeStatic-11.png";
            return PipeStatic(id, type, property, path);
          default:
            path = "PipeStatic-Vertical.png";
            return PipeStatic(id, type, property, path);
        }

      default:
        return EmptyFreeTile(id, type, property, "Empty-Free.png");
    }
  }*/
}

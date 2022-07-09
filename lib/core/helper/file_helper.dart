import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../feature/repository/repository.dart';

class FileHelper {
  static FileHelper? _instance;

  static FileHelper get instance {
    _instance ??= FileHelper._init();
    return _instance!;
  }

  FileHelper._init();
  List<String> tilesInfoList = [];
  List<String> allLevels = [];
  int currentLevelNumber = 0;
  String currentPath = "";
  incrementLevel() {
    if (currentLevelNumber + 1 < allLevels.length) {
      currentLevelNumber++;
    }
  }

  decreaseLevel() {
    if (currentLevelNumber >= 0) {
      currentLevelNumber--;
    }
  }

  Future<void> readLevel() async {
    tilesInfoList.clear();

    if (currentLevelNumber < allLevels.length) {
      currentPath = allLevels[currentLevelNumber];
      String result =
          await rootBundle.loadString(allLevels[currentLevelNumber]);

      List<String> levelItems = result.trim().split("\n");
      tilesInfoList = levelItems;
    }
  }

  Future<void> readLevelByGivenLevel(int level) async {
    GameRepository.instance.newGameLevel();
    tilesInfoList.clear();
    currentLevelNumber = level;

    if (level < allLevels.length) {
      currentPath = allLevels[currentLevelNumber];
      String result =
          await rootBundle.loadString(allLevels[currentLevelNumber]);

      List<String> levelItems = result.trim().split("\n");
      tilesInfoList = levelItems;
    }
  }

  Future<void> readAllLevels() async {
    try {
      //  var b = await rootBundle.("assets/levels/");
      final manifestJson = await rootBundle.loadString('AssetManifest.json');

      allLevels = json
          .decode(manifestJson)
          .keys
          .where((String key) => key.startsWith('assets/levels'))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future<String> readfiveLevels() async {
    try {
      return await rootBundle.loadString('assets/levels/5x5.TXT');
    } catch (e) {
      print(e);
      throw Exception("File error");
    }
  }
}

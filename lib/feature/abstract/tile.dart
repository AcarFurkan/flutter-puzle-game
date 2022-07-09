import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
 
import '../../core/enums/properties_enum.dart';
import '../../core/enums/types_enum.dart';
import '../repository/repository.dart';

abstract class Tile extends Image {
  late String _id;

  //late String type;
  //late String property;
  late Types _type;
  late Properties _property;

  late String _path;
  String get id => this._id;

  get getType => _type;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tile && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => this.hashCode;

  set setType(String type) {
    if (type.toLowerCase() == ("starter")) {
      _type = Types.STARTER;
    } else if (type.toLowerCase() == ("end")) {
      _type = Types.END;
    } else if (type.toLowerCase() == ("empty")) {
      _type = Types.EMPTY;
    } else if (type.toLowerCase() == ("pipe")) {
      _type = Types.PIPE;
    } else if (type.toLowerCase() == ("pipestatic")) {
      _type = Types.PIPESTATIC;
    } else {
      _type = Types.EMPTY;
    }
  }

  get getProperty => _property;

  set setProperty(String property) {
    if (property.toLowerCase() == ("vertical")) {
      _property = Properties.VERTICAL;
    } else if (property.toLowerCase() == ("verticalup")) {
      _property = Properties.VERTICALUP;
    } else if (property.toLowerCase() == ("verticaldown")) {
      _property = Properties.VERTICALDOWN;
    } else if (property.toLowerCase() == ("horizontal")) {
      _property = Properties.HORIZONTAL;
    } else if (property.toLowerCase() == ("horizontalleft")) {
      _property = Properties.HORIZONTALLEFT;
    } else if (property.toLowerCase() == ("horizontalright")) {
      _property = Properties.HORIZONTALRIGHT;
    } else if (property.toLowerCase() == ("none")) {
      _property = Properties.NONE;
    } else if (property.toLowerCase() == ("free")) {
      _property = Properties.FREE;
    } else if (property.toLowerCase() == ("00")) {
      _property = Properties.CURVED_ZERO_ZERO;
    } else if (property.toLowerCase() == ("01")) {
      _property = Properties.CURVED_ZERO_ONE;
    } else if (property.toLowerCase() == ("10")) {
      _property = Properties.CURVED_ONE_ZERO;
    } else if (property.toLowerCase() == ("11")) {
      _property = Properties.CURVED_ONE_ONE;
    } else {
      _property = Properties.NONE;
    }
  }

  void goToRight() {}

  void goToLeft() {}

  void goToUp() {}

  void goToDown() {}
  String get getPath => _path;

  set setPath(path) {
    String temp = "assets/tiles/";
    _path = temp + path;
  }

  Tile(this._id, String type, String property, this._path, {Key? key})
      : super.asset('assets/tiles/$_path',
            key: key, width: GameRepository.instance.width / 4) {
    log(id + _path);
    setProperty = property;
    setType = type;
  }

  Tile.fromTile(Tile tile, {Key? key}) : super.asset(tile._path, key: key) {
    this._id = tile._id;
    this._path = tile._path;
    this._property = tile._property;
    this._type = tile._type;
  }
}

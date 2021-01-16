import 'package:flutter/material.dart';

int startId = 0;

class TileAnimation {
  Animation<double> x;
  Animation<double> y;

  TileAnimation(this.x, this.y);
}

class Tile {
  final int value;
  int _id;

  int get id => _id;

  int lastX;
  int lastY;

  TileAnimation tileAnimation;

  set id(int id) {
    throw Exception("Can't set ID!");
  }

  bool hasJustBeenMerged;

  Tile(this.value, {this.hasJustBeenMerged = false, this.lastX, this.lastY}) {
    this._id = startId++;
    this.tileAnimation = TileAnimation(null, null);
  }

  bool operator ==(other) => other is Tile && other.value == value;

  static Tile merge(Tile a, Tile b) {
    return Tile(a.value + b.value, hasJustBeenMerged: true);
  }

  @override
  String toString() {
    return value.toString();
  }
}

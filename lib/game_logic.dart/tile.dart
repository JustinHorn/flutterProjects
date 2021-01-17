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
  bool didJustSpawn;

  TileAnimation tileAnimation;

  Animation<double> size;

  set id(int id) {
    throw Exception("Can't set ID!");
  }

  bool hasJustBeenMerged;

  Tile(this.value,
      {this.hasJustBeenMerged = false,
      this.lastX,
      this.lastY,
      this.didJustSpawn = true}) {
    this._id = startId++;
    this.tileAnimation = TileAnimation(null, null);
  }

  bool operator ==(other) => other is Tile && other.value == value;

  void bounce(Animation<double> parent) {
    size = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.9), weight: 0.9),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1.0)));
  }

  static Tile merge(Tile a, Tile b) {
    return Tile(a.value + b.value, hasJustBeenMerged: true);
  }

  @override
  String toString() {
    return value.toString();
  }
}

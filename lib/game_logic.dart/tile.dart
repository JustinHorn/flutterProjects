import 'package:flutter/material.dart';

int startId = 0;

class TileAnimation {
  int id = 0;
  Animation<double> x;
  Animation<double> y;
  Animation<double> size;

  int value;

  void bounce(Animation<double> parent) {
    size = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.9), weight: 0.9),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1.0)));
  }

  TileAnimation(
    Tile tile,
  ) {
    this.id = tile.id;
    setStopped(tile);
    this.value = tile.value;
  }

  void setStopped(
    Tile tile,
  ) {
    this.x = AlwaysStoppedAnimation(tile.lastX.toDouble());
    this.y = AlwaysStoppedAnimation(tile.lastY.toDouble());
    this.size = AlwaysStoppedAnimation(0.9);
  }

  void setAnimation(Tile tile, newX, newY, controller) {
    this.x = Tween<double>(begin: tile.lastX.toDouble(), end: newX.toDouble())
        .animate(controller);
    this.y = Tween<double>(begin: tile.lastY.toDouble(), end: newY.toDouble())
        .animate(controller);
  }
}

class Tile {
  final int value;
  int _id;

  int get id => _id;

  int lastX;
  int lastY;
  bool didJustSpawn;

  List<int> parents;

  set id(int id) {
    throw Exception("Can't set ID!");
  }

  bool hasJustBeenMerged;

  Tile(
    this.value, {
    this.hasJustBeenMerged = false,
    this.lastX,
    this.lastY,
    this.didJustSpawn = true,
    this.parents,
  }) {
    if (parents == null) {
      parents = [null, null];
    }
    this._id = startId++;
  }

  bool operator ==(other) => other is Tile && other.value == value;

  static Tile merge(Tile a, Tile b) {
    return Tile(
      a.value + b.value,
      hasJustBeenMerged: true,
      didJustSpawn: false,
      parents: [a.id, b.id],
    );
  }

  @override
  String toString() {
    return value.toString();
  }
}

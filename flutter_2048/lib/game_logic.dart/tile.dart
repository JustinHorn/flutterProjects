import 'package:flutter/material.dart';

int startId = 0;

class Tile {
  final int value;
  int _id;

  int get id => _id;

  bool didJustSpawn;

  List<int> parents;

  set id(int id) {
    throw Exception("Can't set ID!");
  }

  bool hasJustBeenMerged;

  Tile(
    this.value, {
    this.hasJustBeenMerged = false,
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

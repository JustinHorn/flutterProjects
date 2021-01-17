import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

abstract class TileAnimation {
  int id = 0;
  Animation<double> x;
  Animation<double> y;
  Animation<double> size;

  int value;

  static TileAnimation spawn(Tile tile, controller) {
    return SpawnTileAnimation(tile, controller);
  }

  static MovingTileAnimation move(Tile tile, newXY, controller) {
    return MovingTileAnimation(tile, newXY, controller);
  }

  void bounce(Animation<double> parent) {
    size = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.9), weight: 0.9),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1.0)));
  }

  void setStopped(
    Tile tile,
  ) {
    this.x = AlwaysStoppedAnimation(tile.lastXY[0].toDouble());
    this.y = AlwaysStoppedAnimation(tile.lastXY[1].toDouble());
    this.size = AlwaysStoppedAnimation(0.9);
  }

  void setAnimation(Tile tile, newXY, controller) {
    this.x = Tween<double>(
            begin: tile.lastXY[0].toDouble(), end: newXY[0].toDouble())
        .animate(controller);
    this.y = Tween<double>(
            begin: tile.lastXY[1].toDouble(), end: newXY[1].toDouble())
        .animate(controller);
  }
}

class SpawnTileAnimation extends TileAnimation {
  SpawnTileAnimation(Tile tile, controller) {
    id = tile.id;
    setStopped(tile);
    value = tile.value;
    bounce(controller);
  }
}

class MovingTileAnimation extends TileAnimation {
  MovingTileAnimation(
    Tile tile,
    newXY,
    controller,
  ) {
    super.id = tile.id;
    setStopped(tile);

    super.value = tile.value;
    setAnimation(tile, newXY, controller);
  }
}

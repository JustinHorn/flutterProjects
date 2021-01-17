import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';

abstract class TileAnimation {
  int id = 0;
  Animation<double> x;
  Animation<double> y;
  Animation<double> size;

  List<int> lastXY = [null, null];

  int value;

  static TileAnimation spawn(Tile tile, lastXY, controller) {
    return SpawnTileAnimation(tile, lastXY, controller);
  }

  static MovingTileAnimation move(Tile tile, lastXY, newXY, controller) {
    return MovingTileAnimation(tile, lastXY, newXY, controller);
  }

  void bounce(Animation<double> parent) {
    size = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 0.8),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0.9), weight: 0.9),
    ]).animate(CurvedAnimation(parent: parent, curve: Interval(0.5, 1.0)));
  }

  void setStopped(List<int> lastXY) {
    this.x = AlwaysStoppedAnimation(lastXY[0].toDouble());
    this.y = AlwaysStoppedAnimation(lastXY[1].toDouble());
    this.size = AlwaysStoppedAnimation(0.9);
  }

  void setAnimation(
      List<int> lastXY, List<int> newXY, AnimationController controller) {
    this.x =
        Tween<double>(begin: lastXY[0].toDouble(), end: newXY[0].toDouble())
            .animate(controller);
    this.y =
        Tween<double>(begin: lastXY[1].toDouble(), end: newXY[1].toDouble())
            .animate(controller);
  }
}

class SpawnTileAnimation extends TileAnimation {
  SpawnTileAnimation(Tile tile, lastXY, controller) {
    id = tile.id;
    setStopped(lastXY);
    value = tile.value;
    bounce(controller);
  }
}

class MovingTileAnimation extends TileAnimation {
  MovingTileAnimation(
    Tile tile,
    newXY,
    lastXY,
    controller,
  ) {
    super.id = tile.id;
    setStopped(lastXY);

    super.value = tile.value;
    setAnimation(lastXY, newXY, controller);
  }
}

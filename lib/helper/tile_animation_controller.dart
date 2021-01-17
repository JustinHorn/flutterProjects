import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';
import 'package:twentyfourtyeight/widgets/tile_animations.dart';
import 'package:twentyfourtyeight/widgets/tile_widget.dart';

import 'functions.dart';

class TileAnimationController {
  List<TileAnimation> tileAnimations = List.empty(growable: true);
  final AnimationController controller;

  TileAnimationController(this.controller);

  animate(List<Tile> tiles, List<Tile> previousTiles, Game game) {
    filterAnimationsByIds(tiles.map((t) => t.id).cast<int>());

    for (int i = 0; i < tiles.length; i++) {
      Tile currentTile = tiles[i];

      List<int> newXY = getXYofTile(currentTile, game);

      if (currentTile.didJustSpawn || currentTile.hasJustBeenMerged) {
        currentTile.lastXY = newXY;

        handleSpawnOrMerge(currentTile, newXY, previousTiles);
      } else {
        handleMovement(currentTile, newXY);
        currentTile.lastXY = newXY;
      }
    }
  }

  initTiles(List<Tile> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].didJustSpawn) {
        tileAnimations.add(TileAnimation.spawn(tiles[i], controller));
      }
    }
  }

  filterAnimationsByIds(Iterable<int> ids) {
    tileAnimations =
        tileAnimations.where((a) => ids.any((id) => id == a.id)).toList();
  }

  setAnimationsToStop(List<Tile> tiles) {
    for (int i = 0; i < tiles.length; i++) {
      int index =
          tileAnimations.indexWhere((element) => element.id == tiles[i].id);

      tileAnimations[index].setStopped(tiles[i]);
    }
  }

  handleSpawnOrMerge(currentTile, newXY, previousTiles) {
    if (currentTile.hasJustBeenMerged) {
      handleMerge(previousTiles, currentTile, newXY);
    }
    tileAnimations.add(TileAnimation.spawn(currentTile, controller));
  }

  void handleMovement(currentTile, newXY) {
    TileAnimation animation =
        tileAnimations.firstWhere((element) => element.id == currentTile.id);

    animation.setAnimation(currentTile, newXY, controller);
  }

  void handleMerge(previousTiles, currentTile, newXY) {
    print(previousTiles.length);
    Tile parentA = previousTiles
        .firstWhere((element) => element.id == currentTile.parents[0]);
    Tile parentB = previousTiles
        .firstWhere((element) => element.id == currentTile.parents[1]);

    tileAnimations.add(TileAnimation.move(parentA, newXY, controller));
    tileAnimations.add(TileAnimation.move(parentB, newXY, controller));
  }

  List<Widget> getAnimatedTileBuilders(fieldSize, distance) {
    return tileAnimations
        .map((animation) => AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                double left = calcPositionOfTile(
                    animation.x.value.floor(), fieldSize, distance);

                double top = calcPositionOfTile(
                    animation.y.value.floor(), fieldSize, distance);

                return TileWidget(
                  left: left - fieldSize * (animation.size.value - 0.9) / 2,
                  top: top - fieldSize * (animation.size.value - 0.9) / 2,
                  size: fieldSize * animation.size.value,
                  value: animation.value,
                );
              },
            ))
        .toList()
        .cast<AnimatedBuilder>();
  }

  double calcPositionOfTile(int position, double size, distance) {
    return position.toDouble() * (size + distance) + distance + size * 0.05;
  }
}

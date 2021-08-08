import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:twentyfourtyeight/game_logic.dart/game.dart';
import 'package:twentyfourtyeight/game_logic.dart/tile.dart';
import 'package:twentyfourtyeight/animations/tile_animations.dart';
import 'package:twentyfourtyeight/helper/functions.dart';
import 'package:twentyfourtyeight/widgets/tile_widget.dart';

class TileAnimationController {
  List<TileAnimation> tileAnimations = List.empty(growable: true);
  final AnimationController controller;
  final Game game;

  TileAnimationController(this.controller, this.game);

  animate() {
    List<Tile> tiles = game.getListOfTiles();

    filterAnimationsByIds(tiles.map((t) => t.id).cast<int>());

    for (int i = 0; i < tiles.length; i++) {
      Tile currentTile = tiles[i];

      List<int> newXY = getXYofTile(currentTile, game.map);

      if (currentTile.didJustSpawn || currentTile.hasJustBeenMerged) {
        handleSpawnOrMerge(currentTile, newXY);
      } else {
        List<int> oldXY = getXYofTile(currentTile, game.previousMap);

        handleMovement(tiles[i].id, oldXY, newXY);
      }
    }
  }

  loadFirstTiles() {
    List<Tile> tiles = game.getListOfTiles();
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i].didJustSpawn) {
        List<int> lastXYOfTile = getXYofTile(tiles[i], game.map);

        tileAnimations
            .add(TileAnimation.spawn(tiles[i], lastXYOfTile, controller));
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

      List<int> lastXYOfTile = getXYofTile(tiles[i], game.map);
      tileAnimations[index].setStopped(lastXYOfTile);
    }
  }

  handleSpawnOrMerge(Tile currentTile, List<int> newXY) {
    if (currentTile.hasJustBeenMerged) {
      handleMerge(currentTile, newXY);
    }
    tileAnimations.add(TileAnimation.spawn(currentTile, newXY, controller));
  }

  void handleMovement(int animationId, List<int> oldXY, List<int> newXY) {
    TileAnimation animation =
        tileAnimations.firstWhere((element) => element.id == animationId);

    animation.setAnimation(oldXY, newXY, controller);
  }

  void handleMerge(currentTile, newXY) {
    List<Tile> previousTiles = game.getListOfPreviousTiles();

    Tile parentA = previousTiles
        .firstWhere((element) => element.id == currentTile.parents[0]);
    Tile parentB = previousTiles
        .firstWhere((element) => element.id == currentTile.parents[1]);

    List<int> lastXYOfA = getXYofTile(parentA, game.previousMap);
    List<int> lastXYOfB = getXYofTile(parentB, game.previousMap);

    tileAnimations
        .add(TileAnimation.move(parentA, lastXYOfA, newXY, controller));
    tileAnimations
        .add(TileAnimation.move(parentB, lastXYOfB, newXY, controller));
  }
}

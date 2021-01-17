import 'dart:math';

import 'move_operations.dart';
import 'tile.dart';
import 'field.dart';

class Game {
  List<Field> map;
  List<Field> previousMap;

  Function onGameMapChange;

  bool gameOver = false;
  bool spawnElements = true; // false for testing puporses

  Random rng = Random();

  Game() {
    map = List<Field>.generate(
        16,
        (index) => Field(
              index,
            ));
    map[0].tile = Tile(2);
    map[3].tile = Tile(2);
  }

  List<Tile> getListOfTiles() {
    return map
        .where((element) => element.hasTile())
        .map((e) => e.tile)
        .toList()
        .cast<Tile>();
  }

  List<Tile> getListOfPreviousTiles() {
    return previousMap
        .where((element) => element.hasTile())
        .map((e) => e.tile)
        .toList()
        .cast<Tile>();
  }

  spawnElement() {
    List<int> emptyIndexes = map
        .where((field) => !field.hasTile())
        .map((field) => field.postion)
        .toList();

    if (emptyIndexes.length > 0) {
      int position = emptyIndexes[rng.nextInt(emptyIndexes.length)];
      map[position].tile = Tile(rng.nextInt(4) == 0 ? 4 : 2);
    }
  }

  moveLeft() {
    beforeRound();
    this.map = MoveOperator(map).moveLeft();

    prepareNextRound();
  }

  moveRight() {
    beforeRound();
    this.map = MoveOperator(map).moveRight();

    prepareNextRound();
  }

  moveUp() {
    beforeRound();
    this.map = MoveOperator(map).moveUp();

    prepareNextRound();
  }

  moveDown() {
    beforeRound();
    this.map = MoveOperator(map).moveDown();
    prepareNextRound();
  }

  void prepareNextRound() {
    if (spawnElements) spawnElement();
    gameOver = !MoveOperator(map).canMove();
    onGameMapChange();
  }

  void beforeRound() {
    previousMap = map;
    for (int i = 0; i < map.length; i++) {
      if (map[i].hasTile()) {
        map[i].tile.hasJustBeenMerged = false;
        map[i].tile.didJustSpawn = false;
      }
    }
  }
}

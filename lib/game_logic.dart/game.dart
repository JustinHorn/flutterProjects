import 'dart:math';

import 'tile.dart';
import 'field.dart';

class Game {
  List<Field> map;

  Function onGameMapChange;

  bool gameOver = false;
  bool spawnElements = true; // false for testing puporses

  Random rng = Random();

  Game(this.onGameMapChange) {
    map = List<Field>.generate(
        16,
        (index) => Field(
              index,
            ));
    map[0].tile = Tile(2, lastX: 0, lastY: 0);
  }

  List<Tile> getListOfTiles() {
    return map
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
      map[position].tile = Tile(2);
    }
  }

  bool canMove() {
    if (canMoveLeft()) return true;
    if (canMoveRight()) return true;
    if (canMoveUp()) return true;
    if (canMoveDown()) return true;
    return false;
  }

  bool canMoveLeft() {
    for (int i = 0; i < 4; i++) {
      for (int j = 1; j < 4; j++) {
        int index = i * 4 + j;
        int nextLine = (i * 4 - 1);
        Function getNext = (int previous) => previous - 1;
        Function inBounds = (int index) => index > nextLine;

        if (canMoveElements(index, getNext, inBounds)) return true;
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int i = 0; i < 4; i++) {
      for (int j = 2; j >= 0; j--) {
        int index = i * 4 + j;
        int nextLine = ((i + 1) * 4);
        Function getNext = (int previous) => previous + 1;
        Function inBounds = (int index) => index < nextLine;

        if (canMoveElements(index, getNext, inBounds)) return true;
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int i = 4; i < map.length; i++) {
      int index = i;
      Function getNext = (int previous) => previous - 4;
      Function inBounds = (int index) => index >= 0;
      if (canMoveElements(index, getNext, inBounds)) return true;
    }
    return false;
  }

  bool canMoveDown() {
    for (int i = map.length - 5; i >= 0; i--) {
      int index = i;
      Function getNext = (int previous) => previous + 4;
      Function inBounds = (int index) => index < map.length;
      if (canMoveElements(index, getNext, inBounds)) return true;
    }
    return false;
  }

  moveLeft() {
    beforeRound();

    for (int i = 0; i < 4; i++) {
      for (int j = 1; j < 4; j++) {
        int index = i * 4 + j;
        int nextLine = (i * 4 - 1);
        Function getNext = (int previous) => previous - 1;
        Function inBounds = (int index) => index > nextLine;

        moveElements(index, getNext, inBounds);
      }
    }
    prepareNextRound();
  }

  moveRight() {
    beforeRound();

    for (int i = 0; i < 4; i++) {
      for (int j = 2; j >= 0; j--) {
        int index = i * 4 + j;
        int nextLine = ((i + 1) * 4);
        Function getNext = (int previous) => previous + 1;
        Function inBounds = (int index) => index < nextLine;
        moveElements(index, getNext, inBounds);
      }
    }
    prepareNextRound();
  }

  moveUp() {
    beforeRound();

    for (int i = 4; i < map.length; i++) {
      int index = i;
      Function getNext = (int previous) => previous - 4;
      Function inBounds = (int index) => index >= 0;
      moveElements(index, getNext, inBounds);
    }
    prepareNextRound();
  }

  moveDown() {
    beforeRound();
    for (int i = map.length - 5; i >= 0; i--) {
      int index = i;
      Function getNext = (int previous) => previous + 4;
      Function inBounds = (int index) => index < map.length;
      moveElements(index, getNext, inBounds);
    }
    prepareNextRound();
  }

  bool canMoveElements(int index, Function getNext, Function inBounds) {
    if (map[index].hasTile()) {
      int next = getNext(index);
      if (!map[next].hasTile()) {
        return true;
      } else if (map[next].tile == map[index].tile) {
        return true;
      }
    }
    return false;
  }

  void moveElements(int index, Function getNext, Function inBounds) {
    if (map[index].hasTile()) {
      int next = getNext(index);
      if (!map[next].hasTile()) {
        int veryNext = getNext(next);
        while (inBounds(veryNext) && !map[veryNext].hasTile()) {
          next = veryNext;
          veryNext = getNext(veryNext);
        }

        if (inBounds(veryNext) &&
            map[veryNext].hasTile() &&
            map[index].tile == map[veryNext].tile &&
            !map[veryNext].tile.hasJustBeenMerged) {
          mergeElements(index, veryNext);
          next = veryNext;
        }

        moveElement(index, next);
      } else if (map[next].tile == map[index].tile) {
        mergeElements(index, next);
        moveElement(index, next);
      }
    }
  }

  mergeElements(int positionMover, int positionCollider) {
    if (map[positionMover].tile != map[positionCollider].tile) {
      throw new Exception(
          "Elements are not allowed to be merged because they are unequal!");
    }

    map[positionMover].tile =
        Tile.merge(map[positionMover].tile, map[positionCollider].tile);
    map[positionCollider].tile = null;
  }

  moveElement(int current, int next) {
    if (!map[current].hasTile()) {
      throw new Exception(
          "Expected to move an element, but no element was there");
    }

    map[next].tile = map[current].tile;
    map[current].tile = null;
  }

  void prepareNextRound() {
    if (spawnElements) spawnElement();
    gameOver = !canMove();
    onGameMapChange();
  }

  void beforeRound() {
    for (int i = 0; i < map.length; i++) {
      if (map[i].hasTile()) {
        map[i].tile.hasJustBeenMerged = false;
        map[i].tile.didJustSpawn = false;
      }
    }
  }
}
